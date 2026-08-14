# Reusable DevSecOps scan templates

Each subfolder is independently reusable. The scripts accept a repository URL and optional destination, clone with a shallow history, verify the required scanner is available or install it through the documented package/release channel, and write results to a report directory.

```text
bash template/python/scan.sh https://github.com/example/application.git
bash template/shell/scan.sh https://github.com/example/application.git
bash template/azure/scan.sh https://github.com/example/application.git
bash template/jenkins/scan.sh https://github.com/example/application.git
bash template/pipeline/scan.sh https://github.com/example/application.git
```

Never put tokens in URLs or scripts. Use `GH_TOKEN`, SSH agent forwarding, or the CI platform's approved checkout mechanism.

## Documentation conventions

- **Structure:** Keep policies, rules, exceptions, reports, and executable helpers in their designated subfolders.
- **Rules:** Deterministic scanner output is authoritative. Failed mandatory controls block unless an approved, unexpired exception matches exactly.
- **Naming:** Use lowercase folder names and the tool convention, such as `opa_<service>_<sequence>.rego`, `tflint_<service>_<sequence>.hcl`, and timestamped report names.
- **Usage:** Read the parent `skills.md` before changing or invoking files. Never store credentials or raw secrets in documentation or reports.



## Additional security scanners

Reusable templates should run Gitleaks for repository-wide secret detection and Checkov for Terraform, Kubernetes, Helm, Docker, and cloud IaC. Use pinned versions from requirements-ci.txt, normalize JSON findings, and apply the shared exception and critical/high release gate.

