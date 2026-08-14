# Jenkins pipeline policies

These policies evaluate a normalized Jenkins pipeline document. The input must expose `agent` and a `stages` array with each stage's `name` and enabled state. Policies require an approved agent and a code scanning stage before deployment controls are evaluated.

Use Conftest after converting a Jenkinsfile to the approved normalized input contract. Do not treat raw Groovy text as trusted structured data.


Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

