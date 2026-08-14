# policy id: opa-kubernetes-005
# reason: enforce organization security control for kubernetes, using OPA, every resource must define metadata.labels
# severity: medium

package organization.kubernetes

import rego.v1

deny contains msg if {
  not input.metadata.labels
  msg := "OPA-K8S-005: every resource must define metadata.labels"
}




