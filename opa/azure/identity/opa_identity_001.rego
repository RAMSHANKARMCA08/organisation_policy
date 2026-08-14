# policy id: opa-identity-001
# reason: enforce organization security control for identity, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.identity
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_role_assignment"
  rc.change.after.role_definition_name in {"Owner", "Contributor"}
  msg := sprintf("OPA-AZ-ID-001: %s grants a broad privileged role", [rc.address])
}




