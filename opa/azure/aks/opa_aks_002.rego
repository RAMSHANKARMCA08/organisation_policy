# policy id: opa-aks-002
# reason: enforce organization security control for aks, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.aks

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_kubernetes_cluster"
  not rc.change.after.azure_policy_enabled == true
  msg := sprintf("OPA-AZ-AKS-002: %s must enable Azure Policy", [rc.address])
}





