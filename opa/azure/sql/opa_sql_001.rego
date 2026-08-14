# policy id: opa-sql-001
# reason: enforce organization security control for sql, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.sql
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_mssql_server"
  rc.change.after.public_network_access_enabled == true
  msg := sprintf("OPA-AZ-SQL-001: %s must disable public network access", [rc.address])
}




