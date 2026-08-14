# policy id: terrascan-kubernetes-022
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.resources

terrascan_kubernetes_022[resource.id] {
  resource := input.kubernetes_deployment[_]
  not resource.config.spec[0].template[0].spec[0].container[0].resources[0].limits
  result := {
    "msg": "Kubernetes deployments must define resource limits",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_022[resource.id] = result
}




