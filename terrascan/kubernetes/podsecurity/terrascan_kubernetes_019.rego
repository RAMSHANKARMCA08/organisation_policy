# policy id: terrascan-kubernetes-019
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.podsecurity

terrascan_kubernetes_019[resource.id] {
  resource := input.kubernetes_pod[_]
  resource.config.spec[0].container[_].security_context[0].privileged == true
  result := {
    "msg": "Kubernetes pods must not be privileged",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_019[resource.id] = result
}




