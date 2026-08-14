# policy id: terrascan-kubernetes-024
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.identity

terrascan_kubernetes_024[resource.id] {
  resource := input.kubernetes_role_binding[_]
  resource.config.role_ref[0].name == "cluster-admin"
  result := {
    "msg": "Kubernetes role bindings must avoid cluster-admin",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_024[resource.id] = result
}




