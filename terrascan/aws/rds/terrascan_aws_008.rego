# policy id: terrascan-aws-008
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.rds

terrascan_aws_008[resource.id] {
  resource := input.aws_db_instance[_]
  resource.config.publicly_accessible == true
  result := {
    "msg": "RDS instances must not be publicly accessible",
    `"resource`": resource.id,
  }
  terrascan_aws_008[resource.id] = result
}




