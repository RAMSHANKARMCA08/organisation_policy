# policy id: opa-terraform-002
# reason: enforce organization security control for terraform, using OPA, policy requirements are satisfied
# severity: medium

package organization.terraform

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_s3_bucket_public_access_block"
  rc.change.after.block_public_acls != true
  msg := sprintf("OPA-TF-002: %s must block public ACLs", [rc.address])
}





