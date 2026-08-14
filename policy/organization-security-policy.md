# Sample organization security policy

Status: SAMPLE — requires security-owner approval.

1. Protect credentials, tokens, private keys, certificates, and connection strings from source control and logs.
2. Use approved secret stores and short-lived credentials.
3. Require deterministic secret, SAST, dependency, IaC, container, and policy scanning as applicable.
4. Block releases on unapproved critical or high findings according to the approved severity matrix.
5. Require least-privilege IAM, RBAC, service accounts, and pipeline identities.
6. Require encryption in transit and at rest for sensitive data.
7. Require audit logging, monitoring, retention, and alerting for production systems.
8. Require approved base images, registries, modules, dependencies, and CI runners.
9. Treat opa/Conftest and admission policies as blocking controls where configured.
10. Make exceptions explicit, time-bound, attributable, and approved outside the AI.
11. Do not weaken policy, suppress findings, or bypass gates to obtain a passing build.
12. Review this sample against the current organization standard before adoption.


