# Jenkins failure runbook

1. Record controller, folder, job, build number, commit, and UTC time.
2. Identify the first failed stage and durable task result.
3. Verify the node label and agent image are approved.
4. Check Jenkinsfile and shared-library changes.
5. Confirm credentials use Jenkins credential bindings.
6. Check logs for leaked variables or workspace secrets.
7. Verify SCM checkout provenance and webhook source.
8. Confirm dependency and plugin versions are governed.
9. Run secret scanning before packaging artifacts.
10. Run semgrep or approved SAST before deployment.
11. Run dependency and container vulnerability scans.
12. Run Terraform, terrascan, and opa checks when applicable.
13. Confirm artifacts are created only after mandatory gates.
14. Verify artifact checksums and provenance.
15. Check production parameters and approval gates.
16. Review shell options and unsafe command construction.
17. Verify service-account permissions are least privilege.
18. Reproduce on an isolated approved agent where possible.
19. Correct the failing rule or code; do not disable the stage.
20. Do not replay a production build to bypass approval.
21. Re-run from the earliest failed deterministic check.
22. Confirm deployment consumes the scanned artifact.
23. Route exceptions to an authorized security approver.
24. Record root cause, build evidence, policy IDs, and follow-up.


