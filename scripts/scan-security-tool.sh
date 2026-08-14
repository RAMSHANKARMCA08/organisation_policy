#!/usr/bin/env bash
set -Eeuo pipefail

TOOL="${1:?tool name is required}"
TOOL_ROOT="${2:?installed tool directory is required}"
REPOSITORY_LIST="${3:?repository list is required}"
REPORT_ROOT="${4:?report directory is required}"

: "${GITHUB_ORG:?Set GITHUB_ORG}"
: "${GH_TOKEN:?Set GH_TOKEN}"

WORK_ROOT="$(mktemp -d)"
trap 'rm -rf "$WORK_ROOT"' EXIT

# Artifact transfer does not preserve executable modes. Python scanner wheels
# can also contain native executables below their package directories.
find "$TOOL_ROOT" -type f -exec chmod u+x {} + 2>/dev/null || true
SITE_PACKAGES="$(find "$TOOL_ROOT/lib" -type d -name site-packages -print -quit 2>/dev/null || true)"
export PYTHONPATH="${SITE_PACKAGES}${PYTHONPATH:+:$PYTHONPATH}"
export PATH="$TOOL_ROOT/bin:$PATH"

scan_repository() {
  local repo="$1"
  local target="$WORK_ROOT/$repo"
  local output="$REPORT_ROOT/$repo"
  local result=0

  mkdir -p "$output"
  if ! gh repo clone "$GITHUB_ORG/$repo" "$target" -- --depth 1 \
    >"$output/${TOOL}-clone.log" 2>&1; then
    printf '1\n' >"$output/${TOOL}.status"
    return 1
  fi

  case "$TOOL" in
    checkov)
      checkov -d "$target" --quiet --skip-path 'helm_chart/templates' \
        >"$output/checkov.log" 2>&1 || result=1
      ;;
    semgrep)
      semgrep scan --config "$GITHUB_WORKSPACE/semgrep/python" \
        --config "$GITHUB_WORKSPACE/semgrep/organization" "$target" \
        >"$output/semgrep.log" 2>&1 || result=1
      ;;
    gitleaks)
      gitleaks detect --source "$target" \
        --config "$GITHUB_WORKSPACE/gitleaks/config/gitleaks.toml" \
        --no-banner >"$output/gitleaks.log" 2>&1 || result=1
      ;;
    trivy)
      trivy fs --scanners vuln,secret --severity CRITICAL,HIGH,MEDIUM "$target" \
        >"$output/trivy.log" 2>&1 || result=1
      ;;
    tflint)
      if find "$target" -type f -name '*.tf' -print -quit | grep -q .; then
        tflint --chdir="$target" --recursive --format compact \
          >"$output/tflint.log" 2>&1 || result=1
      else
        echo "No Terraform files detected." >"$output/tflint.log"
      fi
      ;;
    kyverno)
      if find "$target" -type f \( -name '*.yaml' -o -name '*.yml' \) -print -quit | grep -q .; then
        kyverno apply "$GITHUB_WORKSPACE/kyverno" --resource "$target" \
          >"$output/kyverno.log" 2>&1 || result=1
      else
        echo "No YAML files detected." >"$output/kyverno.log"
      fi
      ;;
    terrascan)
      terrascan scan -d "$target" -o human \
        >"$output/terrascan.log" 2>&1 || result=1
      ;;
  esac

  printf '%s\n' "$result" >"$output/${TOOL}.status"
  return "$result"
}

failures=0
while IFS= read -r repo; do
  [[ -z "$repo" ]] && continue
  [[ "$repo" =~ ^[A-Za-z0-9._-]+$ ]] || {
    echo "invalid repository name: $repo" >&2
    failures=$((failures + 1))
    continue
  }
  scan_repository "$repo" || failures=$((failures + 1))
done <"$REPOSITORY_LIST"

printf '{"tool":"%s","failed_repositories":%d}\n' \
  "$TOOL" "$failures" >"$REPORT_ROOT/${TOOL}-summary.json"

exit "$((failures > 0 ? 1 : 0))"
