# Template skills

Use a technology-specific reusable scan template. Each template may include shell helpers and Azure Pipeline examples. Do not embed credentials; pass repository access through approved CI credentials.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

