# opa exception index

Policy-local exception folders exist under every opa policy directory. Store records below the repository-specific path and validate them against ..\..\exceptions\README.md before any approved suppression.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

