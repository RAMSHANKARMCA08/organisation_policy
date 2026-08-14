# policy id: opa-kubernetes-010
# reason: enforce organization security control for kubernetes, using OPA, HorizontalPodAutoscaler must use minReplicas=3 and maxReplicas=10
# severity: medium

package organization.kubernetes

import rego.v1

deny contains msg if {
  input.kind == "HorizontalPodAutoscaler"
  input.spec.minReplicas != 3 or input.spec.maxReplicas != 10
  msg := "OPA-K8S-010: HorizontalPodAutoscaler must use minReplicas=3 and maxReplicas=10"
}




