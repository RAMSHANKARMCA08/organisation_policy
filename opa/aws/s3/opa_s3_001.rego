# policy id: opa-s3-001
# reason: enforce organization security control for s3, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.s3
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_public_access_block"
  not rc.change.after.block_public_acls == true
  msg := sprintf("OPA-AWS-S3-001: %s must block public ACLs", [rc.address])
}




