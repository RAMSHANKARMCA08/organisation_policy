# opa skills

Use this folder for organization policy-as-code. Select the provider or technology folder based on repository classification, run Conftest/opa against the correct input contract, and keep one denial policy per Rego file. Use opa_<service>_<sequence>.rego; store repository-scoped exception metadata only in the designated exception folders. Never weaken a rule to pass a scan.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

