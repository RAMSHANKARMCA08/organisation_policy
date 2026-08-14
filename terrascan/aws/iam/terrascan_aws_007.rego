# policy id: terrascan-aws-007
# reason: enforce organization security control for aws, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.aws.iam

terrascan_aws_007[resource.id] {
  resource := input.aws_iam_policy[_]
  policy := json.unmarshal(resource.config.policy); statement := policy.Statement[_]; statement.Effect == "Allow"; statement.Action == "*"
  result := {
    "msg": "IAM policies must not allow wildcard actions",
    `"resource`": resource.id,
  }
  terrascan_aws_007[resource.id] = result
}




