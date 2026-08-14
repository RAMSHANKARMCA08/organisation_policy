# trivy organization policy index

This catalogue contains 30 controls. trivy capabilities are mapped rather than replaced with fabricated custom rule syntax

| Policy ID | Category | Severity | Description | Implementation | Status |
|---|---|---|---|---|---|
| trivy-docker-001 | docker | high | Detect containers configured to run as root where detectable. | trivy built-in misconfiguration scan | active |
| trivy-docker-002 | docker | critical | Detect privileged container configuration. | trivy built-in misconfiguration scan | active |
| trivy-docker-003 | docker | high | Detect insecure or excessive Linux capabilities. | trivy built-in misconfiguration scan | active |
| trivy-docker-004 | docker | high | Detect insecure container configuration or security settings. | trivy built-in misconfiguration scan | active |
| trivy-docker-005 | docker | high | Detect unapproved or insecure base-image practices where supported. | trivy built-in misconfiguration scan | active |
| trivy-docker-006 | docker | medium | Detect sensitive or unnecessary exposed ports/configuration where supported. | trivy built-in misconfiguration scan | active |
| trivy-docker-007 | docker | critical | Detect known vulnerabilities in image OS/application packages. | trivy image vulnerability scan | active |
| trivy-kubernetes-001 | kubernetes | critical | Containers must not run as privileged. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-002 | kubernetes | high | Containers should run as non-root. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-003 | kubernetes | high | Detect dangerous Linux capabilities. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-004 | kubernetes | high | Detect hostNetwork usage. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-005 | kubernetes | high | Detect hostPID usage. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-006 | kubernetes | high | Detect hostIPC usage. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-007 | kubernetes | high | Detect insecure hostPath usage. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-008 | kubernetes | medium | Require appropriate CPU and memory resources. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-009 | kubernetes | high | Detect insecure container securityContext configuration. | trivy built-in misconfiguration scan | active |
| trivy-kubernetes-010 | kubernetes | high | Detect mutable or latest image tags where supported. | trivy built-in misconfiguration scan | active |
| trivy-secrets-001 | secrets | critical | Detect passwords, tokens, API keys, and credentials. | trivy built-in secret scan | active |
| trivy-secrets-002 | secrets | critical | Detect AWS and other provider credentials. | trivy built-in secret scan | active |
| trivy-secrets-003 | secrets | critical | Detect private keys, authentication tokens, and high-risk secrets. | trivy built-in secret scan | active |
| trivy-terraform-001 | terraform | high | Detect publicly accessible S3 configuration. | trivy built-in IaC misconfiguration scan | active |
| trivy-terraform-002 | terraform | high | Detect unencrypted storage/resources where supported. | trivy built-in IaC misconfiguration scan | active |
| trivy-terraform-003 | terraform | critical | Detect unrestricted SSH/RDP access from the internet. | trivy built-in IaC misconfiguration scan | active |
| trivy-terraform-004 | terraform | critical | Detect publicly accessible database configuration. | trivy built-in IaC misconfiguration scan | active |
| trivy-terraform-005 | terraform | high | Detect excessive wildcard IAM permissions where supported. | trivy built-in IaC misconfiguration scan | active |
| trivy-terraform-006 | terraform | high | Detect missing logging, encryption, or security controls. | trivy built-in IaC misconfiguration scan | active |
| trivy-vulnerability-001 | vulnerability | critical | Detect critical vulnerabilities. | trivy vulnerability scan severity gate | active |
| trivy-vulnerability-002 | vulnerability | high | Detect high vulnerabilities. | trivy vulnerability scan severity gate | active |
| trivy-vulnerability-003 | vulnerability | high | Detect vulnerable application dependencies and packages. | trivy filesystem vulnerability scan | active |
| trivy-vulnerability-004 | vulnerability | high | Detect container OS and base-image vulnerabilities. | trivy image vulnerability scan | active |

critical and high findings block by default. Exceptions must be approved, time-bound, and repository-scoped.




