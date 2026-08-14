# policy id: terrascan-docker-025
# reason: enforce organization security control for docker, using Terrascan, ensure no latest image is used
# severity: high

package organization.terrascan.docker.image

terrascan_docker_025[resource.id] {
  resource := input.docker_image[_]
  resource.config.name == "latest"
  result := {
    "msg": "Docker images must use approved immutable tags",
    `"resource`": resource.id,
  }
  terrascan_docker_025[resource.id] = result
}



