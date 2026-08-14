#!/usr/bin/env bash
set -Eeuo pipefail

REPOSITORY_URL="${1:?Usage: scan.sh <repository-url> [output-directory]}"
OUTPUT="${2:-scan-output/pipeline}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --depth 1 "$REPOSITORY_URL" "$WORK/repository"
mkdir -p "$OUTPUT"
command -v semgrep >/dev/null || { echo 'Install Semgrep from the approved package source.' >&2; exit 2; }

semgrep scan --config semgrep/jenkins --config semgrep/organization --json-output "$OUTPUT/semgrep.json" "$WORK/repository" >"$OUTPUT/semgrep.txt" 2>&1 || true
if command -v conftest >/dev/null; then
  conftest test "$WORK/repository" --policy opa/azure-pipeline >"$OUTPUT/conftest.txt" 2>&1 || true
else
  echo 'Conftest unavailable; install it from the approved release source.' >"$OUTPUT/conftest.txt"
fi




# Gitleaks: scan repository content for secrets.
gitleaks detect --source "$WORK/repository" --config "$PWD/gitleaks/config/gitleaks.toml" --no-banner

# Checkov: scan Terraform, Kubernetes, Helm, Docker, and cloud IaC.
checkov -d "$WORK/repository" --output json --output-file-path "$OUTPUT/checkov.json"


