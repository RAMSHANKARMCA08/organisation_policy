# policy id: terrascan-docker-026
# reason: enforce organization security control for docker, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.docker.runtime

terrascan_docker_026[resource.id] {
  resource := input.docker_container[_]
  resource.config.privileged == true
  result := {
    "msg": "Docker containers must not run privileged",
    `"resource`": resource.id,
  }
  terrascan_docker_026[resource.id] = result
}




