# policy id: opa-sql-002
# reason: enforce organization security control for sql, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.sql

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_mssql_server"
  rc.change.after.minimum_tls_version != "1.2"
  msg := sprintf("OPA-AZ-SQL-002: %s must require TLS 1.2 or later", [rc.address])
}





