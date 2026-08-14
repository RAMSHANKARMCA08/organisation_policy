# policy id: terrascan-aws-001
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.s3

terrascan_aws_001[resource.id] {
  resource := input.aws_s3_bucket[_]
  not resource.config.acl == "private"
  result := {
    "msg": "S3 buckets must not allow public ACLs",
    `"resource`": resource.id,
  }
  terrascan_aws_001[resource.id] = result
}




