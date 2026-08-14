# policy id: opa-storage-004
# reason: enforce organization security control for storage, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.storage

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_account"
  rc.change.after.allow_nested_items_to_be_public == true
  msg := sprintf("OPA-AZ-STG-004: %s must prohibit public blob/container access", [rc.address])
}





