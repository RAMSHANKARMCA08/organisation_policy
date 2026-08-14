#!/usr/bin/env bash
set -Eeuo pipefail

: "${GITHUB_ORG:?Set GITHUB_ORG}"
: "${GH_TOKEN:?Set GH_TOKEN}"

OUTPUT_FILE="${1:-repository-names.txt}"
EXCEPTION_FILE="${2:-repository/scan-exceptions.txt}"
INVENTORY_FILE="${3:-repository/discovered-repositories.yaml}"

command -v gh >/dev/null || { echo "gh is required" >&2; exit 2; }

# sort and comm must use identical byte-wise ordering.
export LC_ALL=C

tmp_all="$(mktemp)"
tmp_configured="$(mktemp)"
tmp_exceptions="$(mktemp)"
trap 'rm -f "$tmp_all" "$tmp_configured" "$tmp_exceptions"' EXIT

# Retrieve all organization repositories without printing credentials.
gh repo list "$GITHUB_ORG" --limit 1000 --json name --jq '.[].name' | sort -u > "$tmp_all"

# Read the explicit scan allow-list from repository metadata files. Generated
# discovery output is excluded because it has not been reviewed and approved.
find repository -maxdepth 1 -type f \( -name '*.yaml' -o -name '*.yml' \) \
  ! -name 'discovered-repositories.yaml' -print0 |
  xargs -0 -r grep -hE '^[[:space:]]*name:[[:space:]]*' |
  awk -F: '{ value=$2; gsub(/^[[:space:]"\047]+|[[:space:]"\047]+$/, "", value); print value }' |
  sort -u > "$tmp_configured"

while IFS= read -r repo; do
  [[ "$repo" =~ ^[A-Za-z0-9._-]+$ ]] || {
    echo "invalid repository name in repository inventory: $repo" >&2
    exit 2
  }
done < "$tmp_configured"

# Read approved exclusions, ignoring blank lines and comments.
if [[ -f "$EXCEPTION_FILE" ]]; then
  sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$EXCEPTION_FILE" | sort -u > "$tmp_exceptions"
fi

# Scan only repositories that are both accessible and explicitly configured,
# then remove exact names with approved scan exclusions.
comm -12 "$tmp_all" "$tmp_configured" |
  comm -23 - "$tmp_exceptions" > "$OUTPUT_FILE"

# Record accessible organization repositories that are not on the scan allow-list.
mkdir -p "$(dirname "$INVENTORY_FILE")"
{
  echo '# Generated inventory entries; complete project and contact fields through review.'
  echo 'repositories:'
  comm -23 "$tmp_all" "$tmp_configured" | while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    echo "  - name: $repo"
    echo '    project: TODO'
    echo '    point_of_contact_1: TODO'
    echo '    point_of_contact_2: TODO'
  done
} > "$INVENTORY_FILE"

echo "Repositories accessible in organization '$GITHUB_ORG':"
if [[ -s "$tmp_all" ]]; then cat "$tmp_all"; else echo '(none)'; fi
echo
echo "Repositories selected for scanning:"
if [[ -s "$OUTPUT_FILE" ]]; then cat "$OUTPUT_FILE"; else echo '(none)'; fi
echo
echo "Missing local metadata entries written to: $INVENTORY_FILE"

