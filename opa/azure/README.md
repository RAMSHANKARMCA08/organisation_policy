# Azure opa policies

These policies evaluate Terraform plan JSON (`terraform show -json`). Each service policy is independently addressable with Conftest.

| Service | Directory | Primary controls |
|---|---|---|
| AKS | `aks/` | Private cluster, Azure Policy, RBAC, monitoring |
| Identity | `identity/` | Broad subscription roles and credential expiry |
| Key Vault | `key-vault/` | Private access, purge protection, retention, RBAC |
| Monitor | `monitor/` | Log retention and diagnostic settings |
| Network | `network/` | Internet exposure of sensitive/all ports |
| SQL | `sql/` | Private access, TLS 1.2, transparent encryption |
| Storage | `storage/` | Private access, infrastructure encryption, TLS, public blobs |

Policy failures are blocking. Validate with `conftest test plan.json --policy opa/azure`.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

