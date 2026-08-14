# policy id: opa-cloudtrail-003
# reason: enforce organization security control for cloudtrail, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.cloudtrail

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_cloudtrail"
  not rc.change.after.include_global_service_events == true
  msg := sprintf("OPA-AWS-CT-003: %s must include global service events", [rc.address])
}





