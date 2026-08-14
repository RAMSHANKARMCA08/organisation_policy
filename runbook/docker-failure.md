# Docker failure runbook

1. Record repository, image, digest or tag, commit, and UTC time.
2. Identify whether build, lint, vulnerability, or runtime failed.
3. Verify builder and registry identities are authorized.
4. Review the Dockerfile change from the last successful build.
5. Confirm the base image is approved and pinned.
6. Check that `latest` is not used where immutable references are required.
7. Check for secrets in `COPY`, `ADD`, arguments, and layers.
8. Review logs for redacted credentials and tokens.
9. Verify package sources and checksum validation.
10. Remove unnecessary packages, caches, and tools.
11. Confirm a non-root runtime user is declared.
12. Check image file ownership and permissions.
13. Check exposed ports and network assumptions.
14. Confirm a health check is configured when required.
15. Run Hadolint against the Dockerfile.
16. Run trivy filesystem and image scans.
17. Generate an SBOM with Syft when required.
18. Match the SBOM with Grype vulnerability data.
19. Run Docker opa policies.
20. Do not add unapproved vulnerability ignores.
21. Rebuild with a clean build context after remediation.
22. Verify pushed and scanned digests are identical.
23. Promote only after mandatory gates and approvals pass.
24. Record root cause, findings, digest, and corrective action.


