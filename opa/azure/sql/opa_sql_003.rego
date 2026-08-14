# policy id: opa-sql-003
# reason: enforce organization security control for sql, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.sql

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_mssql_database"
  rc.change.after.transparent_data_encryption_enabled == false
  msg := sprintf("OPA-AZ-SQL-003: %s must enable transparent data encryption", [rc.address])
}





