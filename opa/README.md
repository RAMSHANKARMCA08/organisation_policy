# Organization opa policies

terrascan policies are maintained separately under `terrascan/`. The `opa/` tree contains only organization opa/Conftest policies. Do not mirror or mix terrascan policy files into this folder.

Cloud service policies under `aws/` and `azure/` evaluate Terraform plan JSON unless a policy states another input contract. Generate input without applying changes:

```text
terraform show -json plan.tfplan > plan.json
conftest test plan.json --policy opa/aws
conftest test plan.json --policy opa/azure
```

Policy failures are blocking. Do not edit a rule or add an ignore merely to make validation pass. Rule changes and exceptions require review through the organization's authorized security process.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

