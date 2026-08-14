# policy id: opa-kubernetes-009
# reason: enforce organization security control for kubernetes, using OPA, metadata.labels.project must contain only lowercase letters, digits, dots, or hyphens
# severity: medium

package organization.kubernetes
import rego.v1
deny contains msg if {
  project := input.metadata.labels.project
  not regex.match(`^[a-z0-9][a-z0-9.-]*$`, project)
  msg := "OPA-K8S-009: metadata.labels.project must contain only lowercase letters, digits, dots, or hyphens"
}




