# Sample secure development standard

Status: SAMPLE — requires security-owner approval.

1. Classify repository content before selecting scanners.
2. Scan source and relevant Git history for secrets.
3. Run SAST and dependency scanning before packaging.
4. Run IaC scanning and opa policy validation before infrastructure changes.
5. Scan Dockerfiles, images, and generated SBOMs before release.
6. Scan Kubernetes and rendered Helm manifests before admission.
7. Pin actions, tasks, images, modules, and dependencies where policy requires.
8. Preserve sanitized scanner evidence and tool versions.
9. Treat unavailable policy or tooling as review, not PASS.
10. Re-run deterministic validation after remediation.
11. Require peer review for security-sensitive changes.
12. Never upload source, policy, logs, or findings to an unapproved service.
13. Do not run destructive production commands from an AI remediation flow.
14. Maintain runbooks for application, pipeline, Terraform, Docker, and Kubernetes failures.
15. Review this sample against the current organization standard before adoption.



