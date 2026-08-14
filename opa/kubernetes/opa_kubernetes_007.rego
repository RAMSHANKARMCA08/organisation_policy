# policy id: opa-kubernetes-007
# reason: enforce organization security control for kubernetes, using OPA, metadata.labels.env must be exactly dev, stage, or prod in lowercase
# severity: medium

package organization.kubernetes
import rego.v1
valid_envs := {"dev", "stage", "prod"}
deny contains msg if {
  env := input.metadata.labels.env
  not valid_envs[env]
  msg := "OPA-K8S-007: metadata.labels.env must be exactly dev, stage, or prod in lowercase"
}




