# Azure Pipeline opa policy groups

Policies are grouped by control area and use one denial rule per Rego file:

- `security/` — security gates before deployment
- `secrets/` — prevention of credential disclosure
- `agents/` — approved agent pools
- `artifacts/` — trusted stage dependencies
- `approvals/` — production approval checks
- `tasks/` — governed or pinned task versions

The policy input contract is the normalized Azure Pipeline structure consumed by the organization’s Conftest adapter. Validate all groups together with `conftest test <input> --policy opa/azure-pipeline`.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

