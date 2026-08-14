# semgrep organization SAST

## Structure

```text
semgrep/<category>/semgrep_<category>_<sequence>.yml
semgrep/POLICY_INDEX.md
```

Exactly 30 sample native semgrep rules are organized under `python`, `shell`, `jenkins`, and `organization`. Each file contains one rule and metadata for policy mapping, normalized severity, security category, remediation, and technology.

## Usage

```text
semgrep scan --config semgrep/python --config semgrep/shell --config semgrep/jenkins --config semgrep/organization --json-output semgrep-report.json <repository>
```

semgrep is SAST. Use Gitleaks for repository-wide secrets, trivy for vulnerabilities and misconfiguration, tflint/terrascan for IaC, kyverno for Kubernetes admission, and opa/Conftest for organization infrastructure policy.



