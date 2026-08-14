# policy id: opa-storage-002
# reason: enforce organization security control for storage, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.storage

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_account"
  not rc.change.after.infrastructure_encryption_enabled == true
  msg := sprintf("OPA-AZ-STG-002: %s must enable infrastructure encryption", [rc.address])
}





