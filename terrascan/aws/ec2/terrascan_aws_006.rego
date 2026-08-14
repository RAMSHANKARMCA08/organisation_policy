# policy id: terrascan-aws-006
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.ec2

terrascan_aws_006[resource.id] {
  resource := input.aws_ebs_volume[_]
  not resource.config.encrypted
  result := {
    "msg": "EBS volumes must be encrypted",
    `"resource`": resource.id,
  }
  terrascan_aws_006[resource.id] = result
}




