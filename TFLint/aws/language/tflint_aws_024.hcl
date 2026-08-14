# policy id: tflint-aws-024
# reason: enforce organization security control for aws, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: aws_instance_previous_iam_profile
rule "aws_instance_previous_iam_profile" {
  enabled = true
}





