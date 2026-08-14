# Repository inventory

Add one YAML file per repository in this folder, with its canonical name, owning
project, and two points of contact. These files are the scan allow-list: the
organization workflow scans only listed repositories that are accessible with
the configured GitHub token. Contact fields are metadata and are not credentials.

Required fields:

```yaml
- name: repository-name
  project: project-name
  point_of_contact_1: person@example.com
  point_of_contact_2: backup@example.com
  visibility: private
  access_scope: individual
  security_severity: medium
```

Repository classification:

- `visibility: public` is always `critical` because source and policy exposure is unrestricted.
- `access_scope: individual` is `medium` when access is intentionally granted to named users and the repository is not public.
- Store `security_severity` as lowercase `critical`, `high`, `medium`, `low`, or `info` and review it when visibility or access changes.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

