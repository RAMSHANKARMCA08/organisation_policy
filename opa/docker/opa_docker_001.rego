# policy id: opa-docker-001
# reason: enforce organization security control for docker, using OPA, ensure no latest image is used
# severity: high

package organization.docker

import rego.v1

deny contains msg if {
  some stage in input
  lower(stage.Cmd) == "from"
  endswith(lower(stage.Value[0]), ":latest")
  msg := "OPA-DOCKER-001: base images must not use the latest tag"
}




