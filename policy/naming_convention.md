# DevSecOps policy and scanner naming convention

This document defines stable names for policy files, scanner rules, configurations, reports, and exceptions. Names must be descriptive, unique within their policy domain, and must not be changed to conceal a failed finding.

## General format

Use this pattern unless a tool has a stricter native convention:

```text
<TOOL>_<SERVICE-OR-CONTROL>_<SEQUENCE>.<extension>
```

Examples: `opa_s3_001.rego`, `trivy_kubernetes_001.yaml`, `semgrep_python_001.yml`, `kyverno_kubernetes_001.yaml`, and `terrascan_aws_s3_001.rego`.

Use three-digit sequences (`001`, `002`), stable service names, and matching in-file rule IDs such as `org-aws-s3-001`.

## opa / Conftest

Store policies under `opa/<provider-or-domain>/<service>/`:

```text
opa/aws/s3/opa_s3_001.rego
opa/azure/storage/opa_storage_001.rego
opa/kubernetes/opa_kubernetes_001.rego
opa/docker/opa_dockerfile_001.rego
opa/azure-pipeline/opa_azure-pipeline_001.rego
```

Use `opa_<service>_<sequence>.rego`. Mirror the directory in the package name and keep policy failures blocking unless an externally approved exception applies.

## trivy

```text
trivy/config/trivy_config_001.yaml
trivy/ignore/trivy_exception_<cve>_<expiry>.yaml
trivy/reports/trivy_<target>_<YYYYMMDD>T<HHMMSS>Z.json
```

Retain the scanner CVE or misconfiguration ID. Never commit raw secrets or add an ignore without a valid, time-bound exception.

## semgrep

```text
semgrep/semgrep_python_001.yml
semgrep/config/semgrep_config_001.yml
semgrep/reports/semgrep_<repository>_<YYYYMMDD>T<HHMMSS>Z.json
```

Use stable rule IDs such as `org-py-001`; severity changes require policy-owner review.

## Kubernetes and kyverno

```text
kyverno/policies/kyverno_k8s_nonroot_001.yaml
kyverno/policies/kyverno_k8s_resources_001.yaml
kyverno/policies/kyverno_k8s_image-registry_001.yaml
kyverno/reports/kyverno_<cluster>_<YYYYMMDD>T<HHMMSS>Z.json
```

Use `kyverno_<scope>_<control>_<sequence>.yaml`. Scan manifests and rendered Helm output with kyverno CLI, kubeconform, kube-score, Kubescape, or Polaris as approved.

## Dockerfiles and containers

```text
docker/opa_dockerfile_001.rego
docker/trivy_image_001.yaml
docker/hadolint_dockerfile_001.yaml
docker/reports/<image>_<YYYYMMDD>T<HHMMSS>Z.json
```

Use Hadolint for Dockerfile linting, trivy for filesystem/image/IaC scanning, Syft for SBOM generation, and Grype for SBOM vulnerability matching. Require non-root execution, pinned base images, no embedded secrets, and a scan before release.

## Azure Pipelines

```text
opa/azure-pipeline/opa_azure-pipeline_001.rego
pipeline/reports/PIPELINE_<repository>_<YYYYMMDD>T<HHMMSS>Z.json
```

Scan `azure-pipelines.yml` and templates for security stages before deployment, approved agents, protected environments, secure variables, trusted artifacts, pinned tasks, and blocked deployment after failed gates. Use opa/Conftest, actionlint where applicable, and pipeline schema validation.

## Terraform and terrascan

```text
terrascan/terrascan_aws_s3_001.rego
terrascan/terrascan_azure_storage_001.rego
terrascan/reports/terrascan_<repository>_<YYYYMMDD>T<HHMMSS>Z.json
```

Use `terrascan_<provider>_<service>_<sequence>.rego` for custom policies. Preserve provider resource addresses in findings and never run `terraform apply` as part of scanning.

## Suggested DevSecOps scan tools

Select tools according to repository technologies and the approved toolchain. Deterministic output is authoritative over LLM judgment.

| Area | Suggested tools | Typical target |
|---|---|---|
| Secrets | Gitleaks, TruffleHog | Source and Git history |
| SAST | semgrep, CodeQL, Bandit | Application source |
| Dependencies | pip-audit, OSV-Scanner, npm audit, Dependabot | Lockfiles and packages |
| Containers | trivy, Grype, Syft, Hadolint | Images, SBOMs, Dockerfiles |
| Kubernetes | kyverno CLI, kubeconform, kube-score, Kubescape, Polaris | YAML and rendered Helm |
| IaC | opa/Conftest, terrascan, Checkov, tfsec | Terraform and cloud IaC |
| Shell | ShellCheck, shfmt | Shell scripts |
| Cloud posture | Prowler, ScoutSuite, Steampipe | Authorized cloud accounts |
| CI/CD | opa/Conftest, actionlint, pipeline schema validation | GitHub Actions and Azure Pipelines |

Use only tools approved for the data classification and environment. Do not upload source, policy, logs, or findings to an unapproved service. A missing tool or unreadable policy is `review`, never silently `PASS`.

Container image policy: image references using the `latest` tag in Dockerfiles, Kubernetes manifests, Helm values, or other YAML configuration are `high` severity. Use an immutable version tag or digest instead.

## Deterministic extensible standard

This convention is the stable contract for Codex, CI/CD, scanners, exception workflows, and audit history.

### Core principle: one rule per file

One security rule equals one policy file. Keep unrelated controls separate so each rule can be independently reviewed, versioned, tested, assigned a severity, mapped to an organization policy, reported, referenced by AI, and granted an approved exception.

### Canonical filename

Use lowercase names with underscores:

```text
<tool>_<category>_<sequence>.<extension>
```

The sequence is exactly three digits and starts at `001`. Use the native extension required by the tool.

Examples:

```text
semgrep_python_001.yml
semgrep_shell_001.yml
semgrep_jenkins_001.yml
opa_kubernetes_001.rego
opa_terraform_001.rego
tflint_terraform_001.hcl
```

Do not use spaces, hyphens, mixed case, special characters, or unpadded numbers. Do not mix aliases such as `k8s`, `kube`, and `kubernetes`; use `kubernetes`. Use `azurepipeline` consistently for Azure Pipeline categories.

### Rule ID mapping

Map the filename deterministically to an uppercase policy ID:

```text
semgrep_python_017.yml  ->  semgrep-python-017
opa_kubernetes_003.rego -> opa-kubernetes-003
```

The policy ID is permanent. Do not change the meaning of an existing ID, reuse a retired sequence, or renumber files to fill gaps.

### Sequence management

Before creating a rule:

1. Identify the tool and standardized category.
2. Search the category directory for the highest sequence.
3. Increment it and format it as three digits.
4. Never overwrite an existing rule or reuse a retired number.

If `001`, `002`, and `004` exist because `003` was retired, the next rule is `005`.

### Required rule metadata

Where supported, every policy record should include:

```text
Rule ID
Rule Name
Tool
Category
Sequence
Severity: critical | high | medium | low | info
Description
Security Risk
Organization Policy Reference
Remediation
Owner
Status: active | disabled | deprecated
```

### Modification and retirement

Improve the detection logic in place when the security requirement is unchanged. Create a new sequence for a genuinely new requirement. Do not delete retired policy files; mark them `deprecated` to preserve audit history.

### Policy catalogue and reporting

Maintain a `POLICY_INDEX.md` catalogue with Policy ID, Tool, Category, Severity, Description, and Status. Scanner reports, CI gates, exceptions, and AI analysis must use the same policy ID. A finding should expose repository, file, line, tool, policy ID, severity, description, remediation, and exception status.

### Exception mapping

Exceptions must reference the exact permanent policy ID and repository:

```text
Policy: semgrep-python-003
Repository: payment-api
Reason: documented business justification and compensating control
Approved by: authorized security approver
Valid till: YYYY-MM-DD
Reference: CHANGE-OR-TICKET-ID
```

Never create an exception from a generic scanner name or filename alone. Exceptions do not authorize the AI to suppress, downgrade, or bypass a finding.






