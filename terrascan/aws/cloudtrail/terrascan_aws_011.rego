# policy id: terrascan-aws-011
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.cloudtrail

terrascan_aws_011[resource.id] {
  resource := input.aws_cloudtrail[_]
  not resource.config.enable_log_file_validation
  result := {
    "msg": "CloudTrail must validate log files",
    `"resource`": resource.id,
  }
  terrascan_aws_011[resource.id] = result
}




