# policy id: tflint-aws-025
# reason: enforce organization security control for aws, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: aws_security_group_rule_invalid_protocol
rule "aws_security_group_rule_invalid_protocol" {
  enabled = true
}





