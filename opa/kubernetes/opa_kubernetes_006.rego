# policy id: opa-kubernetes-006
# reason: enforce organization security control for kubernetes, using OPA, metadata.labels.env is mandatory
# severity: medium

package organization.kubernetes
import rego.v1
deny contains msg if {
  not input.metadata.labels.env
  msg := "OPA-K8S-006: metadata.labels.env is mandatory"
}




