# policy id: opa-ec2-002
# reason: enforce organization security control for ec2, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.ec2

import rego.v1

sensitive_ports := {22, 3389, 3306, 5432, 6379, 9200}

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_instance"
  not rc.change.after.metadata_options[0].http_tokens == "required"
  msg := sprintf("OPA-AWS-EC2-002: %s must require IMDSv2", [rc.address])
}





