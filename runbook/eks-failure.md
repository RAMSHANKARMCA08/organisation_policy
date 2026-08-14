# EKS Failure Runbook

## Purpose

Use this runbook for Amazon EKS deployment and production incidents. It is a diagnostic reference, not authorization to change production. Sanitize all evidence before sharing it with an AI or external service.

## Initial evidence

1. Record incident ID, UTC time, AWS account, region, cluster, environment, namespace, and application.
2. Record the failed deployment, image digest, pipeline run, and recent approved change.
3. Verify the operator has read-only diagnostic authorization.
4. Run `aws sts get-caller-identity` and confirm the expected account.
5. Run `aws eks describe-cluster --name <cluster> --region <region>`.
6. Run `kubectl cluster-info` and record only sanitized output.
7. Run `kubectl get nodes -o wide`.
8. Run `kubectl get pods -A` and `kubectl get events -A --sort-by=.lastTimestamp`.
9. Preserve deployment, service, ingress, and Helm revision information.
10. Remove tokens, Secret values, private data, and connection strings from evidence.

## API server unreachable

11. Check `kubectl config current-context` and kubeconfig account/region.
12. Check VPN, DNS, private endpoint routing, security groups, and network ACLs.
13. Refresh kubeconfig only through the approved operator workflow.
14. Do not modify endpoint access, IAM, security groups, or NACLs automatically.

## Node and scheduling failures

15. For `NotReady`, inspect node conditions, kubelet events, CNI status, and resource pressure.
16. Check `MemoryPressure`, `DiskPressure`, `PIDPressure`, and `NetworkUnavailable`.
17. For pending pods, inspect requests, limits, affinity, taints, tolerations, and PVC status.
18. Cordon or drain a node only with explicit operational approval.
19. Allow managed node groups or autoscaling to replace unhealthy nodes through the approved process.

## Pod and image failures

20. For `CrashLoopBackOff`, inspect current and previous logs, exit code, probes, and configuration references.
21. For `OOMKilled`, compare usage with limits and investigate leaks or traffic before increasing memory.
22. For `ImagePullBackOff`, verify the ECR repository, immutable digest, region, and pull permissions.
23. Never print Kubernetes Secret values, registry credentials, or cloud credentials.

## Service, ingress, network, and DNS

24. Check Service selectors, pod labels, endpoints, ports, and target ports.
25. Check Ingress, load balancer controller health, target health, TLS, DNS, and security groups.
26. Check `aws-node` and CoreDNS status, logs, subnet IP capacity, and NetworkPolicy paths.
27. Use temporary diagnostic pods only when approved and use approved, pinned images.

## Deployment, Helm, and security gates

28. Check rollout status and history before considering rollback.
29. Run `helm lint` and `helm template` before applying a chart change.
30. Do not execute `kubectl delete`, `helm rollback`, or production rollback automatically.
31. Run trivy, kyverno, opa/Conftest, schema, and rendered-Helm validation before deployment.
32. Require non-root containers, resource requests/limits, probes, approved registries, and least-privilege RBAC.
33. A failed mandatory scanner or policy gate blocks deployment; AI must not override it.

## AI restrictions and escalation

34. AI may explain sanitized evidence, correlate runbooks, and propose the smallest compliant fix.
35. AI must not modify IAM/RBAC, disable scanners, alter opa rules, approve exceptions, or delete production resources.
36. Escalate cluster, node, ALB, CNI, DNS, IAM, or autoscaling issues to DevOps/SRE.
37. Escalate policy ambiguity, suspected exposure, or secrets to Security.
38. Obtain application-owner approval for application configuration or rollback decisions.

## Closure

39. Confirm nodes are Ready, pods are Ready, endpoints exist, targets are healthy, and alerts are cleared.
40. Re-run deterministic security and health validation after remediation.
41. Record root cause, sanitized evidence, policy IDs, owner, remediation, approvals, and MTTR.
42. Create an RCA and corrective-action items when customer impact or a security control failure occurred.

**Golden rule:** AI assists troubleshooting; deterministic tools enforce policy; humans authorize production-impacting decisions.


