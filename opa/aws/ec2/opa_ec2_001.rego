# policy id: opa-ec2-001
# reason: enforce organization security control for ec2, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.ec2
import rego.v1
sensitive_ports := {22, 3389, 3306, 5432, 6379, 9200}
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_security_group_rule"
  rc.change.after.type == "ingress"
  rc.change.after.cidr_blocks[_] == "0.0.0.0/0"
  port := sensitive_ports[_]
  rc.change.after.from_port <= port
  rc.change.after.to_port >= port
  msg := sprintf("OPA-AWS-EC2-001: %s exposes sensitive port %d to the internet", [rc.address, port])
}




