# policy id: tflint-aws-029
# reason: enforce organization security control for aws, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: aws_s3_bucket_invalid_region
rule "aws_s3_bucket_invalid_region" {
  enabled = true
}





