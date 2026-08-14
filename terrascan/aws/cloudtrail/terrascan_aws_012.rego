# policy id: terrascan-aws-012
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.cloudtrail

terrascan_aws_012[resource.id] {
  resource := input.aws_cloudtrail[_]
  not resource.config.is_multi_region_trail
  result := {
    "msg": "CloudTrail must be multi-region",
    `"resource`": resource.id,
  }
  terrascan_aws_012[resource.id] = result
}




