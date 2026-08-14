# policy id: tflint-terraform-009
# reason: enforce organization security control for terraform, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: terraform_module_pinned_source
rule "terraform_module_pinned_source" {
  enabled = true
}





