# AWS opa policies

These policies evaluate Terraform plan JSON (`terraform show -json`). Each service policy is independently addressable with Conftest. The root policy is named `opa_aws_001.rego` and contains cross-service IAM safeguards.

| Service | Directory | Primary controls |
|---|---|---|
| CloudTrail | `cloudtrail/` | Multi-region trail, global events, log validation |
| EC2 | `ec2/` | IMDSv2, EBS encryption, sensitive ingress |
| EKS | `eks/` | Private endpoint, control-plane logs, KMS secrets encryption |
| IAM | `iam/` | Wildcard actions/resources |
| KMS | `kms/` | Key rotation and enabled keys |
| RDS | `rds/` | Public access, encryption, backups, deletion protection |
| S3 | `s3/` | Public access blocks and approved encryption |

Policy failures are blocking. Validate with `conftest test plan.json --policy opa/aws`.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.





Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

