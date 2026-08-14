# policy id: opa-kubernetes-005
# reason: enforce organization security control for kubernetes, using OPA, policy requirements are satisfied
# severity: medium

package organization.exception.example_repo.kubernetes

import rego.v1

# Metadata only; this package intentionally defines no allow or skip rule.
exception_record := {
  "repository": "example-repo",
  "rego_file": "opa/kubernetes/OPA_kubernetes_005.rego",
  "rule_id": "OPA-K8S-005",
  "initiated_by": "requestor@example.com",
  "initiated_on": "2026-08-14",
  "approved_by": "security-approver@example.com",
  "approved_on": "2026-08-14",
  "valid_till": "2026-09-14",
  "reason": "SAMPLE - replace with approved business justification and compensating control.",
  "ticket": "CHANGE-OR-TICKET-ID",
  "status": "PENDING_APPROVAL",
}




