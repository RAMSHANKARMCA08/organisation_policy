# policy id: opa-iam-001
# reason: enforce organization security control for iam, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.iam
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type in {"aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy"}
  policy := json.unmarshal(rc.change.after.policy)
  statement := policy.Statement[_]
  statement.Effect == "Allow"
  statement.Action == "*"
  msg := sprintf("OPA-AWS-IAM-001: %s grants wildcard actions", [rc.address])
}




