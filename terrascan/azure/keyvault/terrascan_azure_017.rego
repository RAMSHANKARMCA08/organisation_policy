# policy id: terrascan-azure-017
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.keyvault

terrascan_azure_017[resource.id] {
  resource := input.azurerm_key_vault[_]
  not resource.config.purge_protection_enabled
  result := {
    "msg": "Key Vault must enable purge protection",
    `"resource`": resource.id,
  }
  terrascan_azure_017[resource.id] = result
}




