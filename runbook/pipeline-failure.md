# CI/CD pipeline failure

1. Identify the failed stage, job, task version, commit, runner/pool, and sanitized error.
2. Confirm that checkout provenance, dependencies, artifacts, and variables are trusted.
3. Resolve the failing deterministic gate; do not disable it, lower severity, or add an unapproved ignore.
4. Keep deployment blocked until all mandatory upstream gates pass.
5. Route production approval and exceptions to authorized humans.
6. Re-run from the earliest affected gate and retain sanitized evidence.
7. Record pipeline provider, project, run ID, branch, and UTC time.
8. Verify the runner or agent pool is organization-approved.
9. Check checkout provenance and dependency source integrity.
10. Confirm secrets come from approved secret stores or secure variables.
11. Check logs for credential printing, tracing, or unsafe diagnostics.
12. Confirm secret scanning runs before packaging artifacts.
13. Confirm SAST and dependency scans run before deployment.
14. Confirm IaC and Terraform validation precede infrastructure apply.
15. Confirm container images are scanned before promotion.
16. Confirm opa/Conftest policy gates are mandatory.
17. Verify artifacts are immutable, signed, and traceable.
18. Confirm production approvals and environment checks are enabled.
19. Check conditions cannot skip failed security stages.
20. Review service connections and permissions for least privilege.
21. Fix the failing rule or code; never weaken the gate.
22. Do not manually approve production to bypass a failure.
23. Re-run from the earliest affected deterministic check.
24. Record root cause, policy IDs, owner, and corrective action.


