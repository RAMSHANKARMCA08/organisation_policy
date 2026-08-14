# Azure Pipeline failure runbook

1. Record organization, project, pipeline, run ID, commit, and UTC time.
2. Identify the first failed stage, job, task, and exit code.
3. Verify the agent pool is organization-approved.
4. Confirm checkout provenance and trigger source.
5. Review YAML templates and parameter expansion.
6. Confirm secrets come from approved stores and secure variables.
7. Check logs for secret printing or shell tracing.
8. Verify tasks and dependencies are pinned or governed.
9. Confirm secret scanning precedes artifact creation.
10. Confirm SAST and dependency scanning precede deployment.
11. Confirm IaC validation precedes Terraform apply.
12. Confirm image scanning precedes promotion.
13. Confirm opa/Conftest validation is mandatory.
14. Check artifact provenance, retention, and integrity.
15. Check production approvals and environment checks.
16. Confirm conditions cannot skip failed security stages.
17. Review service connections for least privilege.
18. Reproduce safely on a clean approved agent.
19. Fix the failing rule or code; never weaken the gate.
20. Do not manually approve production to bypass a failure.
21. Re-run from the earliest affected deterministic gate.
22. Verify the promoted artifact digest was scanned.
23. Route exceptions to an authorized security approver.
24. Record root cause, run ID, policy IDs, and corrective action.


