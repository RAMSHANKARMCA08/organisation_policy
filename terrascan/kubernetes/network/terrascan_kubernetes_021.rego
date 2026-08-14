# policy id: terrascan-kubernetes-021
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.network

terrascan_kubernetes_021[resource.id] {
  resource := input.kubernetes_service[_]
  resource.config.spec[0].type == "LoadBalancer"
  result := {
    "msg": "Kubernetes services should not use unrestricted LoadBalancer exposure",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_021[resource.id] = result
}




