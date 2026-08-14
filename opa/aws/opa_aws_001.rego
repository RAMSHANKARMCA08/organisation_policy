# policy id: opa-aws-001
# reason: enforce organization security control for aws, using OPA, wildcard IAM actions are prohibited
# severity: medium

package organization.aws
import rego.v1
deny contains msg if {
  statement := input.Statement[_]
  statement.Effect == "Allow"
  statement.Action == "*"
  msg := "OPA-AWS-001: wildcard IAM actions are prohibited"
}




