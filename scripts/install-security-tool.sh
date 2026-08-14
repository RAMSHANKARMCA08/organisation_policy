#!/usr/bin/env bash
set -Eeuo pipefail

TOOL="${1:?tool name is required}"
VERSION_CONFIG="${2:?version configuration is required}"
OUTPUT="${3:?output directory is required}"

VERSION_KEY="${TOOL^^}_VERSION"
VERSION="$(sed -nE "s/^${VERSION_KEY}=([^[:space:]]+)$/\1/p" "$VERSION_CONFIG")"
if [[ -z "$VERSION" || ! "$VERSION" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "missing or invalid $VERSION_KEY in $VERSION_CONFIG" >&2
  exit 2
fi

mkdir -p "$OUTPUT/bin"

download() {
  curl --fail --location --silent --show-error "$1" -o "$2"
}

case "$TOOL" in
  checkov | semgrep)
    python -m pip install --disable-pip-version-check \
      --prefix "$OUTPUT" "$TOOL==$VERSION"
    ;;
  gitleaks)
    archive="$RUNNER_TEMP/gitleaks.tar.gz"
    download \
      "https://github.com/gitleaks/gitleaks/releases/download/v${VERSION}/gitleaks_${VERSION}_linux_x64.tar.gz" \
      "$archive"
    tar -xzf "$archive" -C "$OUTPUT/bin" gitleaks
    ;;
  trivy)
    installer="$RUNNER_TEMP/trivy-install.sh"
    download \
      "https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh" \
      "$installer"
    sh "$installer" -b "$OUTPUT/bin" "v$VERSION"
    ;;
  tflint)
    archive="$RUNNER_TEMP/tflint.zip"
    download \
      "https://github.com/terraform-linters/tflint/releases/download/v${VERSION}/tflint_linux_amd64.zip" \
      "$archive"
    unzip -q "$archive" -d "$OUTPUT/bin"
    ;;
  kyverno)
    archive="$RUNNER_TEMP/kyverno.tar.gz"
    download \
      "https://github.com/kyverno/kyverno/releases/download/v${VERSION}/kyverno-cli_v${VERSION}_linux_x86_64.tar.gz" \
      "$archive"
    tar -xzf "$archive" -C "$OUTPUT/bin" kyverno
    ;;
  terrascan)
    archive="$RUNNER_TEMP/terrascan.tar.gz"
    download \
      "https://github.com/tenable/terrascan/releases/download/v${VERSION}/terrascan_${VERSION}_Linux_x86_64.tar.gz" \
      "$archive"
    tar -xzf "$archive" -C "$OUTPUT/bin" terrascan
    ;;
  *)
    echo "unsupported security tool: $TOOL" >&2
    exit 2
    ;;
esac

find "$OUTPUT/bin" -type f -exec chmod +x {} +
printf '%s=%s\n' "$TOOL" "$VERSION" >"$OUTPUT/version.txt"
