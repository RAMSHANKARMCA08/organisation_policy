# policy id: tflint-terraform-010
# reason: enforce organization security control for terraform, using TFLint, policy requirements are satisfied
# severity: medium

// Native TFLint configuration fragment: terraform_module_shallow_clone
rule "terraform_module_shallow_clone" {
  enabled = true
}





