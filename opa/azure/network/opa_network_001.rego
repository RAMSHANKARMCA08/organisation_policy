# policy id: opa-network-001
# reason: enforce organization security control for network, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.network
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_network_security_rule"
  lower(rc.change.after.direction) == "inbound"
  lower(rc.change.after.access) == "allow"
  rc.change.after.source_address_prefix in {"*", "0.0.0.0/0", "Internet"}
  msg := sprintf("OPA-AZ-NET-001: %s allows inbound internet access", [rc.address])
}




