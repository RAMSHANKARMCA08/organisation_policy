# policy id: opa-azure-pipeline-002
# reason: enforce organization security control for azure-pipeline, using OPA, security validation must run before deployment
# severity: medium

package organization.azure_pipeline.security
import rego.v1
deny contains msg if {
  input.stages
  deploy_index := indexof([lower(object.get(s, "stage", "")) | s := input.stages[_]], "deploy")
  security_index := indexof([lower(object.get(s, "stage", "")) | s := input.stages[_]], "security")
  deploy_index >= 0
  security_index >= deploy_index
  msg := "OPA-AZP-002: security validation must run before deployment"
}




