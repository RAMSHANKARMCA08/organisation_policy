# policy id: opa-docker-002
# reason: enforce organization security control for docker, using OPA, Dockerfile must declare a non-root runtime USER
# severity: medium

package organization.docker

import rego.v1

deny contains msg if {
  not some stage in input
  lower(stage.Cmd) == "user"
  msg := "OPA-DOCKER-002: Dockerfile must declare a non-root runtime USER"
}





