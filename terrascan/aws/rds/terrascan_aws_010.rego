# policy id: terrascan-aws-010
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.rds

terrascan_aws_010[resource.id] {
  resource := input.aws_db_instance[_]
  resource.config.backup_retention_period < 7
  result := {
    "msg": "RDS must retain backups",
    `"resource`": resource.id,
  }
  terrascan_aws_010[resource.id] = result
}




