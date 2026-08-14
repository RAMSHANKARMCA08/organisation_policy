# policy id: tflint-aws-028
# reason: enforce organization security control for aws, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: aws_s3_bucket_invalid_acl
rule "aws_s3_bucket_invalid_acl" {
  enabled = true
}





