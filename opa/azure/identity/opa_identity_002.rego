# policy id: opa-identity-002
# reason: enforce organization security control for identity, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.identity

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azuread_application_password"
  not rc.change.after.end_date_relative
  not rc.change.after.end_date
  msg := sprintf("OPA-AZ-ID-002: %s must have an explicit expiry", [rc.address])
}





