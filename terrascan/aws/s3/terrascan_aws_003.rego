# policy id: terrascan-aws-003
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.s3

terrascan_aws_003[resource.id] {
  resource := input.aws_s3_bucket_server_side_encryption_configuration[_]
  count(resource.config.rule) == 0
  result := {
    "msg": "S3 buckets must use server-side encryption",
    `"resource`": resource.id,
  }
  terrascan_aws_003[resource.id] = result
}




