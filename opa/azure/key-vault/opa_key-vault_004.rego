# policy id: opa-key-vault-004
# reason: enforce organization security control for key-vault, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.key_vault

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_key_vault"
  not rc.change.after.enable_rbac_authorization == true
  msg := sprintf("OPA-AZ-KV-004: %s must use Azure RBAC authorization", [rc.address])
}





