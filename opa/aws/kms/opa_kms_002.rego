# policy id: opa-kms-002
# reason: enforce organization security control for kms, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.kms

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_kms_key"
  rc.change.after.is_enabled == false
  msg := sprintf("OPA-AWS-KMS-002: %s must not provision a disabled key", [rc.address])
}





