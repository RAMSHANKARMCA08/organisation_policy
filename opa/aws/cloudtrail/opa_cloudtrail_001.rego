# policy id: opa-cloudtrail-001
# reason: enforce organization security control for cloudtrail, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.cloudtrail
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_cloudtrail"
  not rc.change.after.is_multi_region_trail == true
  msg := sprintf("OPA-AWS-CT-001: %s must be multi-region", [rc.address])
}




