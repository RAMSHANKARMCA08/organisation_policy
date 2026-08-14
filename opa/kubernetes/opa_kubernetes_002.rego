# policy id: opa-kubernetes-002
# reason: enforce organization security control for kubernetes, using OPA, policy requirements are satisfied
# severity: medium

package organization.kubernetes

import rego.v1

workload_kinds := {"Deployment", "StatefulSet", "DaemonSet", "Job", "CronJob"}

deny contains msg if {
  workload_kinds[input.kind]
  container := input.spec.template.spec.containers[_]
  not container.resources.requests
  msg := sprintf("OPA-K8S-002: container %q must define resource requests", [container.name])
}





