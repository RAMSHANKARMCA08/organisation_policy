# policy id: opa-kubernetes-004
# reason: enforce organization security control for kubernetes, using OPA, hostNetwork is prohibited
# severity: medium

package organization.kubernetes

import rego.v1

workload_kinds := {"Deployment", "StatefulSet", "DaemonSet", "Job", "CronJob"}

deny contains msg if {
  workload_kinds[input.kind]
  input.spec.template.spec.hostNetwork == true
  msg := "OPA-K8S-004: hostNetwork is prohibited"
}





