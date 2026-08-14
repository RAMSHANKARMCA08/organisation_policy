---
name: organization-devsecops-security-auditor
description: Create and audit repositories against organization DevSecOps controls. Use semgrep as the standard SAST scanner for Python, shell, Jenkins, and other supported source files; combine it with Gitleaks, trivy, tflint, terrascan, kyverno, and opa/Conftest according to repository contents.
---

# Organization DevSecOps security auditor

Classify repository contents before scanning. Use deterministic tool output as authoritative and never weaken a gate to make a build pass.

## Scanner selection

- Python (`.py`, `pyproject.toml`, requirements and lock files): semgrep Python rules, Bandit, and dependency scanning.
- Shell (`.sh`, `.bash`, shell shebangs): semgrep shell rules and ShellCheck.
- Jenkins (`Jenkinsfile`, Groovy pipeline files): semgrep Jenkins rules and Jenkins opa policies.
- Azure Pipelines: semgrep pipeline rules and Azure Pipeline opa policies.
- Terraform: tflint, terrascan, and opa/Conftest; semgrep is not an IaC replacement.
- Dockerfiles/images: Hadolint and trivy; retain opa container policies.
- Kubernetes/Helm YAML: kyverno, trivy, and opa/Conftest.
- Repository-wide credentials: Gitleaks; semgrep does not replace secret scanning.

## trivy security policy pack

Use the 30-control catalogue under `trivy/POLICY_INDEX.md` and one metadata file per control under `trivy/<category>/`. trivy is the detection mechanism for vulnerabilities, secrets, supported misconfigurations, licenses, and SBOMs; do not invent unsupported custom trivy rule syntax. Prefer built-in trivy checks, then approved configuration, then a documented CI/CD or organization-policy layer.

Run only relevant modes for detected repository content:

```text
trivy fs --scanners vuln,misconfig,secret --severity high,critical --format json --output trivy-report.json <repository>
trivy config --severity high,critical <repository>
trivy image --severity high,critical <image>
```

Normalize findings to `critical`, `high`, `medium`, `low`, or `info`. critical and high findings block unless an approved, unexpired repository exception exists. Redact secrets and preserve machine-readable fields including repository, policy ID, category, severity, resource, file, line, CVE, package, fixed version, remediation, and exception status.

## semgrep SAST workflow

Run `semgrep scan --config semgrep/python --config semgrep/shell --config semgrep/jenkins --config semgrep/organization --json-output semgrep-report.json <repository>`. Preserve repository, file, line, semgrep rule ID, organization policy ID, normalized severity, category, description, remediation, and exception status. Sanitize evidence and never expose secrets.

Normalize severities to `critical`, `high`, `medium`, `low`, or `info`. critical and high findings fail the security stage unless an externally approved, unexpired exception matches the repository and exact policy.

## CI validation and release gates

The scheduled workflow generates one normalized finding contract with repository, file, line, tool, policy ID, severity, category, description, remediation, and exception status. Run `python scripts/normalize_findings.py` after scanner execution, then run `python scripts/validate_security_controls.py --findings normalized-findings.json`. The validator uses `policy/exception.schema.json`, rejects duplicate policy IDs, and blocks unapproved critical or high findings.

Repository names must match `^[A-Za-z0-9._-]+$`. Clone targets are resolved beneath a temporary workspace and removed after the scan. CI dependencies are pinned in `requirements-ci.txt`; downloaded scanner binaries must be installed through approved setup actions or verified releases.

Terraform and scanner versions are centrally pinned in `config/tool-versions.env`. Update that file through dependency review when upgrading Terraform, Checkov, or Gitleaks.

## AI remediation boundary

semgrep finding → organization policy lookup → sanitized AI explanation → remediation recommendation → developer change → deterministic semgrep re-scan.

AI must not disable rules, suppress findings, alter severity, approve exceptions, expose credentials, or bypass a gate. Keep Gitleaks, trivy, Checkov/terrascan, tflint, kyverno, and opa/Conftest for their respective domains.




