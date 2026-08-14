# policy id: tflint-terraform-018
# reason: enforce organization security control for terraform, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: terraform_unused_required_providers
rule "terraform_unused_required_providers" {
  enabled = true
}





