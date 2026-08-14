# policy id: terrascan-azure-015
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.sql

terrascan_azure_015[resource.id] {
  resource := input.azurerm_mssql_server[_]
  resource.config.public_network_access_enabled == true
  result := {
    "msg": "Azure SQL must disable public network access",
    `"resource`": resource.id,
  }
  terrascan_azure_015[resource.id] = result
}




