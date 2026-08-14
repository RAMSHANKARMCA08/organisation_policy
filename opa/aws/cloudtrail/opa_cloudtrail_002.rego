# policy id: opa-cloudtrail-002
# reason: enforce organization security control for cloudtrail, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.cloudtrail

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_cloudtrail"
  not rc.change.after.enable_log_file_validation == true
  msg := sprintf("OPA-AWS-CT-002: %s must enable log-file validation", [rc.address])
}





