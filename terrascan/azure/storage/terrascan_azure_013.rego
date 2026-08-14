# policy id: terrascan-azure-013
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.storage

terrascan_azure_013[resource.id] {
  resource := input.azurerm_storage_account[_]
  resource.config.min_tls_version != "TLS1_2"
  result := {
    "msg": "Azure storage must require TLS 1.2",
    `"resource`": resource.id,
  }
  terrascan_azure_013[resource.id] = result
}




