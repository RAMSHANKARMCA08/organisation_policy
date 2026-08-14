# Script skills

Use scripts for deterministic repository discovery and scanner orchestration. Preserve sanitized output, fail mandatory gates, avoid production mutation, and keep tool paths configurable through environment variables.

`normalize_findings.py` converts scanner output into the shared JSON finding contract. `validate_security_controls.py` validates `policy/exception.schema.json`, detects duplicate policy IDs, and enforces the critical/high release gate. Repository names must match `^[A-Za-z0-9._-]+$`; clone repositories into temporary directories and verify resolved paths remain inside the workspace.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

