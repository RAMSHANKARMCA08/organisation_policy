# policy id: opa-aks-004
# reason: enforce organization security control for aks, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.aks

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_kubernetes_cluster"
  count(rc.change.after.oms_agent) == 0
  msg := sprintf("OPA-AZ-AKS-004: %s must enable monitoring", [rc.address])
}





