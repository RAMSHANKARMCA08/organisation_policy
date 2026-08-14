# policy id: opa-azure-pipeline-004
# reason: enforce organization security control for azure-pipeline, using OPA, pipeline must declare an organization-approved agent pool
# severity: medium

package organization.azure_pipeline.agents
import rego.v1
deny contains msg if {
  pool := input.pool
  not pool.name
  not pool.vmImage
  msg := "OPA-AZP-004: pipeline must declare an organization-approved agent pool"
}




