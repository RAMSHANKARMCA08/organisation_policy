# policy id: opa-azure-pipeline-009
# reason: enforce organization security control for azure-pipeline, using OPA, pipeline must contain an enabled code scanning stage
# severity: medium

package organization.azure_pipeline.security

import rego.v1

deny contains msg if {
  stages := object.get(input, "stages", [])
  not some stage in stages {
    lower(object.get(stage, "stage", "")) in {"scancode", "scan", "security", "semgrep", "securityscan"}
  }
  msg := "opa-azurepipeline-009: pipeline must contain an enabled code scanning stage"
}




