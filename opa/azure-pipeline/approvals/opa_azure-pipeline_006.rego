# policy id: opa-azure-pipeline-006
# reason: enforce organization security control for azure-pipeline, using OPA, production deployment requires an approval check
# severity: medium

package organization.azure_pipeline.approvals
import rego.v1
deny contains msg if {
  stage := input.stages[_]
  lower(object.get(stage, "stage", "")) == "deploy"
  lower(object.get(stage, "environment", "")) == "production"
  not stage.approval_check
  msg := "OPA-AZP-006: production deployment requires an approval check"
}




