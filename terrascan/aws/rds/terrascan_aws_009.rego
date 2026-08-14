# policy id: terrascan-aws-009
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.rds

terrascan_aws_009[resource.id] {
  resource := input.aws_db_instance[_]
  not resource.config.storage_encrypted
  result := {
    "msg": "RDS storage must be encrypted",
    `"resource`": resource.id,
  }
  terrascan_aws_009[resource.id] = result
}




