# policy id: opa-storage-001
# reason: enforce organization security control for storage, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.storage
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_account"
  rc.change.after.public_network_access_enabled == true
  msg := sprintf("OPA-AZ-STG-001: %s must disable public network access", [rc.address])
}




