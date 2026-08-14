# policy id: terrascan-aws-002
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.s3

terrascan_aws_002[resource.id] {
  resource := input.aws_s3_bucket[_]
  not resource.config.versioning[0].enabled
  result := {
    "msg": "S3 buckets must enable versioning",
    `"resource`": resource.id,
  }
  terrascan_aws_002[resource.id] = result
}




