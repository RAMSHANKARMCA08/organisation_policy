# policy id: terrascan-docker-027
# reason: enforce organization security control for docker, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.docker.runtime

terrascan_docker_027[resource.id] {
  resource := input.docker_container[_]
  resource.config.user == ""
  result := {
    "msg": "Docker containers should run as non-root",
    `"resource`": resource.id,
  }
  terrascan_docker_027[resource.id] = result
}




