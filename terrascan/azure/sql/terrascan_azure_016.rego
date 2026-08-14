# policy id: terrascan-azure-016
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.sql

terrascan_azure_016[resource.id] {
  resource := input.azurerm_mssql_server[_]
  resource.config.minimum_tls_version != "1.2"
  result := {
    "msg": "Azure SQL must require TLS 1.2",
    `"resource`": resource.id,
  }
  terrascan_azure_016[resource.id] = result
}




