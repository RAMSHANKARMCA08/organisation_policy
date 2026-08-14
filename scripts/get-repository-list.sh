#!/usr/bin/env bash
set -Eeuo pipefail

: "${GITHUB_ORG:?Set GITHUB_ORG}"
: "${GH_TOKEN:?Set GH_TOKEN}"

OUTPUT_FILE="${1:-repository-names.txt}"
EXCEPTION_FILE="${2:-repository/scan-exceptions.txt}"
INVENTORY_FILE="${3:-repository/discovered-repositories.yaml}"

command -v gh >/dev/null || { echo "gh is required" >&2; exit 2; }

tmp_all="$(mktemp)"
tmp_exceptions="$(mktemp)"
trap 'rm -f "$tmp_all" "$tmp_exceptions"' EXIT

# Retrieve all organization repositories without printing credentials.
gh repo list "$GITHUB_ORG" --limit 1000 --json name --jq '.[].name' | sort -f > "$tmp_all"

# Read approved exclusions, ignoring blank lines and comments.
if [[ -f "$EXCEPTION_FILE" ]]; then
  sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$EXCEPTION_FILE" | sort -fu > "$tmp_exceptions"
fi

# Exclude only exact repository names and write a reusable artifact.
comm -23 "$tmp_all" "$tmp_exceptions" > "$OUTPUT_FILE"

# Record selected repositories that do not have local metadata under repository/.
mkdir -p "$(dirname "$INVENTORY_FILE")"
{
  echo '# Generated inventory entries; complete project and contact fields through review.'
  echo 'repositories:'
  while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    if ! grep -Rqs --include='*.yaml' --include='*.yml' "^[[:space:]]*name:[[:space:]]*$repo[[:space:]]*$" repository 2>/dev/null; then
      echo "  - name: $repo"
      echo '    project: TODO'
      echo '    point_of_contact_1: TODO'
      echo '    point_of_contact_2: TODO'
    fi
  done < "$OUTPUT_FILE"
} > "$INVENTORY_FILE"

echo "Repositories selected for scanning:"
cat "$OUTPUT_FILE"
echo "Missing local metadata entries written to: $INVENTORY_FILE"

