# policy id: opa-kubernetes-008
# reason: enforce organization security control for kubernetes, using OPA, metadata.labels.project is mandatory
# severity: medium

package organization.kubernetes
import rego.v1
deny contains msg if {
  not input.metadata.labels.project
  msg := "OPA-K8S-008: metadata.labels.project is mandatory"
}




