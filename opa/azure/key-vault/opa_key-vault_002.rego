# policy id: opa-key-vault-002
# reason: enforce organization security control for key-vault, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.key_vault

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_key_vault"
  not rc.change.after.purge_protection_enabled == true
  msg := sprintf("OPA-AZ-KV-002: %s must enable purge protection", [rc.address])
}





