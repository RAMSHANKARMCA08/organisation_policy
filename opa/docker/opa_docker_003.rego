# policy id: opa-docker-003
# reason: enforce organization security control for docker, using OPA, ensure no latest image is used
# severity: high

package organization.docker

import rego.v1

# severity: high
deny contains msg if {
  image := object.get(input, "image", "")
  endswith(lower(image), ":latest")
  msg := "opa-docker-003: Docker image references must use an immutable version or digest, not latest"
}



