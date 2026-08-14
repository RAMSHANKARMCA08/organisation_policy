# policy id: terrascan-aws-005
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.ec2

terrascan_aws_005[resource.id] {
  resource := input.aws_instance[_]
  not resource.config.metadata_options[0].http_tokens == "required"
  result := {
    "msg": "EC2 instances must require IMDSv2",
    `"resource`": resource.id,
  }
  terrascan_aws_005[resource.id] = result
}




