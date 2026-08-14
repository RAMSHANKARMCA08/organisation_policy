# opa policy exceptions

Place only repository-scoped, externally approved exception records here. Use one YAML file per repository and name it after the exact policy file:

```text
<repository-name>/opa_<service>_<sequence>.yaml
```

Required fields include `repository`, `rego_file`, `rule_id`, `initiated_by`, `initiated_on`, `approved_by`, `approved_on`, `valid_till`, `reason`, `ticket`, and `status`. An expired, unapproved, wildcard, or malformed record does not authorize a bypass. Never put secrets in an exception record.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

