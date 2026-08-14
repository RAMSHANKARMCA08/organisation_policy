# policy id: terrascan-kubernetes-023
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.network

terrascan_kubernetes_023[resource.id] {
  resource := input.kubernetes_ingress[_]
  count(resource.config.spec[0].tls) == 0
  result := {
    "msg": "Kubernetes ingress must configure TLS",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_023[resource.id] = result
}




