# Terraform failure

1. Capture the command, exit code, Terraform version, backend/workspace identity, and sanitized diagnostic.
2. Run formatting and validation, then create a saved plan through the approved workflow.
3. Check provider authentication, state locking, module versions, drift, and relevant `ORG-TF-*` results.
4. Review destructive replacements and public-access changes with a human approver.
5. Never edit remote state or run `terraform apply` automatically.
6. Re-run validation, IaC scanning, Conftest, and the approved plan workflow.
7. Confirm the repository commit and workspace are expected.
8. Verify provider versions and approved module sources.
9. Check backend encryption, access controls, and state-lock status.
10. Confirm credentials are short-lived and never printed.
11. Run `terraform fmt -check` on changed files.
12. Run `terraform validate` before generating a plan.
13. Review resource additions, replacements, and destroys.
14. Check public endpoints, open security groups, and firewall rules.
15. Check encryption, logging, monitoring, backups, and mandatory tags.
16. Check IAM actions and resources for wildcard permissions.
17. Run Checkov, trivy, terrascan, and organization opa policies.
18. Review drift and out-of-band changes with the resource owner.
19. Require human approval for destructive or production changes.
20. Never bypass a failed policy with an unapproved ignore.
21. Do not edit remote state to force a passing plan.
22. Re-run all deterministic checks after remediation.
23. Apply only through the authorized deployment workflow.
24. Record root cause, plan reference, approver, and follow-up.


