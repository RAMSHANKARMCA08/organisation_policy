# policy id: terrascan-azure-014
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.storage

terrascan_azure_014[resource.id] {
  resource := input.azurerm_storage_account[_]
  resource.config.allow_nested_items_to_be_public == true
  result := {
    "msg": "Azure storage must disable public access",
    `"resource`": resource.id,
  }
  terrascan_azure_014[resource.id] = result
}




