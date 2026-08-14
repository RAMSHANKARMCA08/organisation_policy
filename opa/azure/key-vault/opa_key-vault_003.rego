# policy id: opa-key-vault-003
# reason: enforce organization security control for key-vault, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.key_vault

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_key_vault"
  not rc.change.after.soft_delete_retention_days >= 7
  msg := sprintf("OPA-AZ-KV-003: %s must retain soft-deleted objects for at least seven days", [rc.address])
}





