# policy id: opa-aks-003
# reason: enforce organization security control for aks, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.aks

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_kubernetes_cluster"
  not rc.change.after.role_based_access_control_enabled == true
  msg := sprintf("OPA-AZ-AKS-003: %s must enable RBAC", [rc.address])
}





