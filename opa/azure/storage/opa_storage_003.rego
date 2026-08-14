# policy id: opa-storage-003
# reason: enforce organization security control for storage, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.storage

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_storage_account"
  rc.change.after.min_tls_version != "TLS1_2"
  msg := sprintf("OPA-AZ-STG-003: %s must require TLS 1.2 or later", [rc.address])
}





