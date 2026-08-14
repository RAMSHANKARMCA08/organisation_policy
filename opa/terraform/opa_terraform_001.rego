# policy id: opa-terraform-001
# reason: enforce organization security control for terraform, using OPA, policy requirements are satisfied
# severity: medium

package organization.terraform

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_security_group_rule"
  rc.change.after.cidr_blocks[_] == "0.0.0.0/0"
  rc.change.after.from_port <= 22
  rc.change.after.to_port >= 22
  msg := sprintf("OPA-TF-001: %s exposes SSH to the internet", [rc.address])
}





