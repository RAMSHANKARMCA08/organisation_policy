# Gitleaks secret scanning

Gitleaks is the repository-wide secret scanner. It scans source files and Git history for credentials, tokens, private keys, and other high-risk secret patterns. It does not replace Semgrep SAST or Trivy vulnerability scanning.

## Usage

```text
gitleaks detect --source . --config gitleaks/config/gitleaks.toml --report-format json --report-path gitleaks.json
```

Findings are normalized with the shared finding contract. Critical and high findings block release unless an approved, unexpired exception matches the exact repository and policy ID. Never add real credentials to allowlists.


This catalogue contains 30 standalone TOML rules under category/folder directories. Each rule has a stable lowercase policy ID, reason, severity, and native Gitleaks regex definition.

