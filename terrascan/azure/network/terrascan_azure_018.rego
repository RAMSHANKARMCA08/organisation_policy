# policy id: terrascan-azure-018
# reason: enforce organization security control for azure, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.azure.network

terrascan_azure_018[resource.id] {
  resource := input.azurerm_network_security_rule[_]
  resource.config.destination_port_range == "3389"; resource.config.source_address_prefix == "*"
  result := {
    "msg": "Azure network rules must not expose RDP to the internet",
    `"resource`": resource.id,
  }
  terrascan_azure_018[resource.id] = result
}




