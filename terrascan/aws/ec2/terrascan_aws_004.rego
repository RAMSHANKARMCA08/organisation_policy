# policy id: terrascan-aws-004
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.ec2

terrascan_aws_004[resource.id] {
  resource := input.aws_security_group_rule[_]
  resource.config.from_port <= 22; resource.config.to_port >= 22; resource.config.cidr_blocks[_] == "0.0.0.0/0"
  result := {
    "msg": "Security groups must not expose SSH to the internet",
    `"resource`": resource.id,
  }
  terrascan_aws_004[resource.id] = result
}




