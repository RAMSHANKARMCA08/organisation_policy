# policy id: opa-network-002
# reason: enforce organization security control for network, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.network

import rego.v1

sensitive_ports := {22, 3389, 1433, 3306, 5432, 6379, 9200}

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_network_security_rule"
  lower(rc.change.after.direction) == "inbound"
  lower(rc.change.after.access) == "allow"
  rc.change.after.source_address_prefix in {"*", "0.0.0.0/0", "Internet"}
  rc.change.after.destination_port_range == "*"
  msg := sprintf("OPA-AZ-NET-002: %s allows all inbound ports from the internet", [rc.address])
}





