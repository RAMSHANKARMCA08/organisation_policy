# policy id: opa-kms-001
# reason: enforce organization security control for kms, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.kms
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_kms_key"
  not rc.change.after.enable_key_rotation == true
  msg := sprintf("OPA-AWS-KMS-001: %s must enable automatic key rotation", [rc.address])
}




