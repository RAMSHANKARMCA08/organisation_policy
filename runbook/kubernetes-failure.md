# Kubernetes failure runbook

1. Record cluster, namespace, kind, resource name, and UTC time.
2. Classify the issue as schema, admission, scheduling, or runtime.
3. Preserve sanitized manifests and event evidence.
4. Check API-server and admission-webhook availability.
5. Validate YAML against the target Kubernetes schema.
6. Render Helm templates before scanning final manifests.
7. Run kyverno policy tests against rendered output.
8. Run Kubernetes opa/Conftest policies.
9. Check required labels and annotations.
10. Check approved image registry and immutable digest.
11. Check non-root, privilege, capabilities, and seccomp settings.
12. Check host networking, host PID/IPC, and HostPath usage.
13. Check resource requests, limits, and probes.
14. Check Service selectors, ports, and endpoints.
15. Check Ingress or LoadBalancer exposure and TLS.
16. Check ServiceAccount, RBAC, and secret references.
17. Check NetworkPolicy coverage and traffic paths.
18. Check rollout strategy and disruption budgets.
19. Compare with the last approved manifest revision.
20. Do not apply a manifest that fails a mandatory gate.
21. Use the authorized rollback workflow if impact continues.
22. Re-run schema, policy, and health checks after remediation.
23. Validate readiness and sanitized logs after deployment.
24. Record root cause, policy IDs, owner, and follow-up.


