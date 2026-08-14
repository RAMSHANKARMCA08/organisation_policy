# Sample policy documents

The Markdown files in this directory are safe, editable examples for local development and policy bootstrapping. They are **not** authoritative organization policy and must not replace approved documents under `pdf/`.

Before declaring compliance, security owners must provide the current approved policy documents through the controlled policy process.

Contents:

- `organization-security-policy.md`
- `coding-standard.md`
- `secure-development-standard.md`
- `deployment-standard.md`
- `naming_convention.md`
- `exception.schema.json`

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.
- **Validation:** Run `python scripts/generate_policy_index.py` and `python scripts/validate_security_controls.py` before merging policy or exception changes.
- **Release gate:** Normalized `critical` and `high` findings block release unless an approved, unexpired repository exception matches the exact policy ID.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

