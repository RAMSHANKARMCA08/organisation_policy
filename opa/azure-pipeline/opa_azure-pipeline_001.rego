# policy id: opa-azure-pipeline-001
# reason: enforce organization security control for azure-pipeline, using OPA, a security stage is required before deployment
# severity: medium

package organization.azure_pipeline

import rego.v1

deny contains msg if {
  input.stages
  deploy_index := indexof([lower(object.get(s, "stage", "")) | s := input.stages[_]], "deploy")
  deploy_index >= 0
  security_index := indexof([lower(object.get(s, "stage", "")) | s := input.stages[_]], "security")
  security_index < 0
  msg := "OPA-AZP-001: a security stage is required before deployment"
}





