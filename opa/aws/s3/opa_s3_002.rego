# policy id: opa-s3-002
# reason: enforce organization security control for s3, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.s3

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_public_access_block"
  after := rc.change.after
  not after.block_public_policy == true
  msg := sprintf("OPA-AWS-S3-002: %s must block public policies", [rc.address])
}





