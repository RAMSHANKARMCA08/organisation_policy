# policy id: opa-azure-pipeline-005
# reason: enforce organization security control for azure-pipeline, using OPA, deployment stage must depend on a trusted build or security stage
# severity: medium

package organization.azure_pipeline.artifacts
import rego.v1
deny contains msg if {
  stage := input.stages[_]
  lower(object.get(stage, "stage", "")) == "deploy"
  not stage.dependsOn
  msg := "OPA-AZP-005: deployment stage must depend on a trusted build or security stage"
}




