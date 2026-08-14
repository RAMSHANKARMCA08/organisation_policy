# Shell scan template

Runs ShellCheck against shell scripts. Usage:

```text
bash template/shell/scan.sh <repository-url> [output-directory]
```

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.



## Additional security scanners

Reusable templates should run Gitleaks for repository-wide secret detection and Checkov for Terraform, Kubernetes, Helm, Docker, and cloud IaC. Use pinned versions from requirements-ci.txt, normalize JSON findings, and apply the shared exception and critical/high release gate.

