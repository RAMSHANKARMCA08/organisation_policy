# policy id: tflint-aws-023
# reason: enforce organization security control for aws, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: aws_instance_invalid_iam_profile
rule "aws_instance_invalid_iam_profile" {
  enabled = true
}





