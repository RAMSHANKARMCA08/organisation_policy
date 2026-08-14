# Sample deployment standard

Status: SAMPLE — requires release and security-owner approval.

1. Deploy only artifacts produced by a trusted, traceable build.
2. Complete mandatory secret, code, dependency, IaC, container, and policy gates first.
3. Require approved production environments, checks, and human approvals.
4. Prevent deployment when a mandatory gate fails.
5. Verify artifact digest and provenance at promotion and deployment.
6. Use least-privilege deployment identities and protected variables.
7. Require health checks, readiness checks, and rollback procedures.
8. Validate Kubernetes security context, resources, probes, and network controls.
9. Validate Terraform plan and review destructive changes before apply.
10. Never auto-apply infrastructure based solely on AI analysis.
11. Record deployment actor, artifact, change reference, environment, and outcome.
12. Monitor post-deployment logs, metrics, traces, and security alerts.
13. Keep rollback artifacts and operational runbooks available.
14. Handle exceptions through an approved, time-bound process.
15. Review this sample against the current organization standard before adoption.


