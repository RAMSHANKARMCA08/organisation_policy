#!/usr/bin/env bash
set -Eeuo pipefail

# Required organization context and output locations.
: "${GITHUB_ORG:?Set GITHUB_ORG}"
: "${GH_TOKEN:?Set GH_TOKEN}"

ROOT="${1:-repositories-to-scan}"
REPORT="${2:-scan-reports}"
REPO_LIST="${3:-repository-names.txt}"

mkdir -p "$ROOT" "$REPORT"
ROOT="$(realpath -m "$ROOT")"
REPORT="$(realpath -m "$REPORT")"
WORKSPACE_ROOT="$(realpath -m "${GITHUB_WORKSPACE:-$(pwd)}")"
case "$ROOT" in "$WORKSPACE_ROOT"/*) ;; *) echo "repository workspace must remain inside checkout" >&2; exit 2 ;; esac
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

# Read the organization repository list supplied by the workflow, or discover it.
command -v gh >/dev/null || { echo "gh is required" >&2; exit 2; }

if [[ -n "$REPO_LIST" && -f "$REPO_LIST" ]]; then
  mapfile -t repos < <(sed '/^[[:space:]]*$/d' "$REPO_LIST")
else
  mapfile -t repos < <(gh repo list "$GITHUB_ORG" --limit 1000 --json name --jq '.[].name')
fi

failures=0

# Run one scanner, retain its log, and add sanitized error details to the report.
run() {
  local name="$1"
  shift
  local tool="${1%% *}"

  if command -v "$tool" >/dev/null 2>&1; then
    if ! "$@" >"$out/$name.log" 2>&1; then
      status=1
      errors+=("$name|high|$(head -c 1000 "$out/$name.log" | tr '\n' ' ')")
    fi
  else
    echo "tool unavailable: $tool" >"$out/$name.log"
    status=1
    errors+=("$name|REVIEW|tool unavailable: $tool")
  fi
}

# Clone and scan each organization repository according to detected file types.
for repo in "${repos[@]}"; do
  [[ "$repo" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "invalid repository name: $repo" >&2; exit 2; }
  target="$ROOT/$repo"
  resolved="$(realpath -m "$target")"
  case "$resolved" in "$ROOT"/*) ;; *) echo "repository path escapes workspace: $repo" >&2; exit 2 ;; esac

  target="$TMP_ROOT/$repo"
  gh repo clone "$GITHUB_ORG/$repo" "$target" -- --depth 1

  out="$REPORT/$repo"
  mkdir -p "$out"
  status=0
  errors=()

  # Repository-wide secrets and IaC security scans.
  run gitleaks gitleaks detect --source "$target" --config "$GITHUB_WORKSPACE/gitleaks/config/gitleaks.toml" --report-format json --report-path "$out/gitleaks.json" --no-banner
  run checkov checkov -d "$target" --output json --output-file-path "$out/checkov.json"

  # Trivy dependency scan: detects Log4j/Log4Shell and other vulnerable components.
  run trivy-vulnerabilities trivy fs --scanners vuln --severity CRITICAL,HIGH,MEDIUM --format json --output "$out/trivy-vulnerabilities.json" "$target"

  # Terraform: validate, scan with Terrascan, and evaluate Terraform OPA policies.
  if find "$target" -type f -name '*.tf' -print -quit | grep -q .; then
    run terraform-validate terraform -chdir="$target" validate -no-color
    run tflint tflint --config "$GITHUB_WORKSPACE/TFLint/.tflint.hcl" --recursive --format compact "$target"
    run terrascan terrascan scan -d "$target" -o json
    run opa conftest test "$target" --policy "$GITHUB_WORKSPACE/opa/terraform"
  fi

  # Shell: scan shell and Bash scripts with ShellCheck.
  if find "$target" -type f \( -name '*.sh' -o -name '*.bash' \) -print -quit | grep -q .; then
    run shellcheck shellcheck $(find "$target" -type f \( -name '*.sh' -o -name '*.bash' \))
  fi

  # Python: run organization Semgrep rules and Bandit analysis.
  if find "$target" -type f -name '*.py' -print -quit | grep -q .; then
    run semgrep-python semgrep scan --config "$GITHUB_WORKSPACE/semgrep/python" --config "$GITHUB_WORKSPACE/semgrep/organization" --json-output "$out/semgrep.json" "$target"
    run bandit bandit -r "$target" -q
  fi

  # Azure Pipelines: evaluate the grouped pipeline OPA policies.
  if find "$target" -type f \( -name 'azure-pipelines.yml' -o -name 'azure-pipelines.yaml' \) -print -quit | grep -q .; then
    run opa-azure-pipeline conftest test "$target" --policy "$GITHUB_WORKSPACE/opa/azure-pipeline"
  fi

  # Jenkins: evaluate governed Jenkins policy rules when Jenkins files are present.
  if find "$target" -type f \( -iname 'jenkinsfile' -o -name '*.groovy' \) -print -quit | grep -q .; then
    run opa-jenkins conftest test "$target" --policy "$GITHUB_WORKSPACE/opa/jenkins"
  fi

  # Docker: lint Dockerfiles, scan configuration, and evaluate Docker OPA policies.
  if find "$target" -type f -iname 'dockerfile*' -print -quit | grep -q .; then
    if grep -RInE '^[[:space:]]*FROM[[:space:]]+[^[:space:]]+:latest([[:space:]]|$)' "$target" --include='Dockerfile*' >/dev/null; then
      status=1; errors+=("image-tag|high|Dockerfile uses the mutable latest image tag")
    fi
    run hadolint hadolint $(find "$target" -type f -iname 'dockerfile*')
    run trivy-docker trivy config "$target"
    run opa-docker conftest test "$target" --policy "$GITHUB_WORKSPACE/opa/docker"
  fi

  # YAML/Kubernetes: apply Kyverno and Kubernetes OPA policies to YAML content.
  if find "$target" -type f \( -name '*.yml' -o -name '*.yaml' \) -print -quit | grep -q .; then
    if grep -RInE '^[[:space:]]*image:[[:space:]]*[^[:space:]]+:latest([[:space:]]|$)' "$target" --include='*.yml' --include='*.yaml' >/dev/null; then
      status=1; errors+=("image-tag|high|YAML or Kubernetes configuration uses the mutable latest image tag")
    fi
    run kyverno kyverno apply "$GITHUB_WORKSPACE/kyverno/policies" --resource "$target"
    run opa-yaml conftest test "$target" --policy "$GITHUB_WORKSPACE/opa/kubernetes"
  fi

  # Write machine-readable and human-readable results for this repository.
  printf '{"repository":"%s","status":"%s"}\n' "$repo" "$status" >"$out/summary.json"

  {
    echo "# DevSecOps scan report: $repo"
    echo
    echo "- Repository: $repo"
    echo "- Organization: $GITHUB_ORG"
    echo "- Status: $([[ $status -eq 0 ]] && echo PASS || echo FAIL)"
    echo "- Priority: $([[ $status -eq 0 ]] && echo NONE || echo high)"
    echo
    echo "## Findings"

    if ((${#errors[@]} == 0)); then
      echo "No scanner errors were reported."
    else
      echo '| Scanner | Priority | Error details |'
      echo '|---|---|---|'

      for finding in "${errors[@]}"; do
        IFS='|' read -r scanner priority detail <<< "$finding"
        echo "| $scanner | $priority | ${detail//|/\\|} |"
      done
    fi

    echo
    echo "Scanner logs are stored beside this report. Secrets must not be added to them."
  } >"$out/report.md"

  (( status != 0 )) && failures=$((failures + 1))
done

# Write the organization-level result and fail the workflow if any repository failed.
printf '{"organization":"%s","repositories":%d,"failed":%d}\n' "$GITHUB_ORG" "${#repos[@]}" "$failures" >"$REPORT/summary.json"

exit "$(( failures > 0 ? 1 : 0 ))"


