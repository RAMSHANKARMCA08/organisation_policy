#!/usr/bin/env bash
set -Eeuo pipefail

REPOSITORY_URL="${1:?Usage: scan.sh <repository-url> [output-directory]}"
OUTPUT="${2:-scan-output/python}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --depth 1 "$REPOSITORY_URL" "$WORK/repository"
mkdir -p "$OUTPUT"
python -m pip install --user semgrep bandit pip-audit checkov==3.2.310

semgrep scan --config semgrep/python --config semgrep/organization --json-output "$OUTPUT/semgrep.json" "$WORK/repository" >"$OUTPUT/semgrep.txt" 2>&1 || true
bandit -r "$WORK/repository" -f json -o "$OUTPUT/bandit.json" || true
if find "$WORK/repository" -maxdepth 2 -type f -name 'requirements*.txt' -print -quit | grep -q .; then
  pip-audit -r "$(find "$WORK/repository" -maxdepth 2 -type f -name 'requirements*.txt' -print -quit)" >"$OUTPUT/pip-audit.txt" 2>&1 || true
fi




# Gitleaks: scan repository content for secrets.
gitleaks detect --source "$WORK/repository" --config "$PWD/gitleaks/config/gitleaks.toml" --no-banner

# Checkov: scan Terraform, Kubernetes, Helm, Docker, and cloud IaC.
checkov -d "$WORK/repository" --output json --output-file-path "$OUTPUT/checkov.json"


