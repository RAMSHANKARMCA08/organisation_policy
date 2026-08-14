# policy id: opa-s3-003
# reason: enforce organization security control for s3, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.s3

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_server_side_encryption_configuration"
  rule := rc.change.after.rule[_]
  rule.apply_server_side_encryption_by_default.sse_algorithm == "AES256"
  msg := sprintf("OPA-AWS-S3-003: %s must use organization-approved KMS encryption", [rc.address])
}





