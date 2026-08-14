# policy id: opa-key-vault-001
# reason: enforce organization security control for key-vault, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.key_vault
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_key_vault"
  rc.change.after.public_network_access_enabled == true
  msg := sprintf("OPA-AZ-KV-001: %s must disable public network access", [rc.address])
}




