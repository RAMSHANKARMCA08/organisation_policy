#!/usr/bin/env bash
set -Eeuo pipefail

REPOSITORY_URL="${1:?Usage: scan.sh <repository-url> [output-directory]}"
OUTPUT="${2:-scan-output/jenkins}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --depth 1 "$REPOSITORY_URL" "$WORK/repository"
mkdir -p "$OUTPUT"
command -v conftest >/dev/null || { echo 'Install Conftest from the approved release source.' >&2; exit 2; }

mapfile -t FILES < <(find "$WORK/repository" -type f \( -iname 'jenkinsfile' -o -name '*.groovy' \))
if ((${#FILES[@]})); then
  conftest test "${FILES[@]}" --policy opa/jenkins >"$OUTPUT/conftest.txt" 2>&1
else
  echo 'No Jenkins pipeline files detected.' >"$OUTPUT/conftest.txt"
fi



# Gitleaks: scan repository content for secrets.
gitleaks detect --source "$WORK/repository" --config "$PWD/gitleaks/config/gitleaks.toml" --no-banner

# Checkov: scan Terraform, Kubernetes, Helm, Docker, and cloud IaC.
checkov -d "$WORK/repository" --output json --output-file-path "$OUTPUT/checkov.json"


