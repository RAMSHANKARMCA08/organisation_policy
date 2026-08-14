# opa repository exceptions

Create one folder per repository under this directory. Each repository folder may contain exactly the two approved Rego exception records required by the exception workflow:

```text
opa/exception/<repository-name>/
├── opa_<service>_<sequence>.rego
└── opa_<service>_<sequence>.rego
```

The folder name must be the canonical repository name. Exception records are metadata for an external approval workflow; they do not override, disable, or lower an opa rule. The workflow must independently verify `repository`, exact `rego_file`, initiator, approval, dates, reason, and ticket before considering an exception.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

