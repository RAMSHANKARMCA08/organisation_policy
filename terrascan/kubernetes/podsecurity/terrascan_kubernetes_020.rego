# policy id: terrascan-kubernetes-020
# reason: enforce organization security control for kubernetes, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.kubernetes.podsecurity

terrascan_kubernetes_020[resource.id] {
  resource := input.kubernetes_pod[_]
  not resource.config.spec[0].security_context[0].run_as_non_root
  result := {
    "msg": "Kubernetes pods should run as non-root",
    `"resource`": resource.id,
  }
  terrascan_kubernetes_020[resource.id] = result
}




