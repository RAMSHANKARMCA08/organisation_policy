# semgrep sample policy index

Exactly 30 one-rule semgrep YAML files are organized by language and security purpose

| Rule ID | Category | Language | Severity | Description | Status |
|---|---|---|---|---|---|
| org-sec-jenkins-001 | jenkins | groovy | high | Jenkinsfiles must not contain hardcoded credentials. | active |
| org-sec-jenkins-002 | jenkins | groovy | high | Jenkins must not print secret variables. | active |
| org-sec-jenkins-003 | jenkins | groovy | high | Groovy interpolation in shell commands can expose secrets. | active |
| org-sec-jenkins-004 | jenkins | groovy | medium | Unrestricted Jenkins agents are not approved. | active |
| org-sec-jenkins-005 | jenkins | groovy | high | Security stages must not be skipped or disabled. | active |
| org-sec-jenkins-006 | jenkins | groovy | high | Production deployment commands require protected gates. | active |
| org-sec-organization-001 | organization | yaml | high | Docker builds must not execute unverified remote scripts. | active |
| org-sec-organization-002 | organization | yaml | high | Container images should not run as root. | active |
| org-sec-organization-003 | organization | yaml | critical | Secrets must not be copied into image layers. | active |
| org-sec-organization-004 | organization | yaml | critical | Kubernetes workloads must not be privileged. | active |
| org-sec-organization-005 | organization | yaml | high | Host networking requires explicit security review. | active |
| org-sec-organization-006 | organization | yaml | critical | Terraform must not expose administrative network access publicly. | active |
| org-sec-organization-007 | organization | yaml | high | Python subprocess shell execution requires safe argument handling. | active |
| org-sec-organization-008 | organization | yaml | critical | Source must not contain hardcoded API credentials. | active |
| org-sec-python-001 | python | python | high | Dangerous eval enables code execution. | active |
| org-sec-python-002 | python | python | high | Dangerous exec enables code execution. | active |
| org-sec-python-003 | python | python | high | Shell execution with dynamic input can enable command injection. | active |
| org-sec-python-004 | python | python | high | Untrusted pickle deserialization can execute code. | active |
| org-sec-python-005 | python | python | high | disabled TLS verification enables interception. | active |
| org-sec-python-006 | python | python | medium | MD5 is weak cryptography. | active |
| org-sec-python-007 | python | python | high | Insecure temporary-file creation is race-prone. | active |
| org-sec-python-008 | python | python | high | os.system can enable command injection. | active |
| org-sec-python-009 | python | python | high | Interpolated SQL can enable SQL injection. | active |
| org-sec-python-010 | python | python | high | Unsafe YAML loading may construct objects. | active |
| org-sec-shell-001 | shell | bash | high | Dynamic eval can execute attacker-controlled shell input. | active |
| org-sec-shell-002 | shell | bash | high | Piping content directly to a shell is unsafe. | active |
| org-sec-shell-003 | shell | bash | high | Piping content directly to Bash is unsafe. | active |
| org-sec-shell-004 | shell | bash | high | World-writable permissions are unsafe. | active |
| org-sec-shell-005 | shell | bash | high | Disabling SSH host verification enables interception. | active |
| org-sec-shell-006 | shell | bash | high | Unvalidated recursive deletion is dangerous. | active |

critical and high findings block unless an approved exception exists.




