#!/usr/bin/env bash
set -Eeuo pipefail

REPOSITORY_URL="${1:?Usage: scan.sh <repository-url> [output-directory]}"
OUTPUT="${2:-scan-output/shell}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --depth 1 "$REPOSITORY_URL" "$WORK/repository"
mkdir -p "$OUTPUT"
command -v shellcheck >/dev/null || {
  echo 'Install ShellCheck from the approved package source.' >&2
  exit 2
}

mapfile -t FILES < <(find "$WORK/repository" -type f \( -name '*.sh' -o -name '*.bash' \))
if ((${#FILES[@]})); then
  shellcheck --format=gcc "${FILES[@]}" >"$OUTPUT/shellcheck.txt"
else
  echo 'No shell files detected.' >"$OUTPUT/shellcheck.txt"
fi

# Gitleaks: scan repository content for secrets.
gitleaks detect --source "$WORK/repository" --config "$PWD/gitleaks/config/gitleaks.toml" --no-banner

# Checkov: scan Terraform, Kubernetes, Helm, Docker, and cloud IaC.
checkov -d "$WORK/repository" --output json --output-file-path "$OUTPUT/checkov.json"
