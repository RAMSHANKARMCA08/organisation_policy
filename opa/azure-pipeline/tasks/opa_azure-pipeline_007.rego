# policy id: opa-azure-pipeline-007
# reason: enforce organization security control for azure-pipeline, using OPA, pipeline tasks must use governed or pinned versions
# severity: medium

package organization.azure_pipeline.tasks
import rego.v1
deny contains msg if {
  task := input.tasks[_]
  task.task
  not regex.match(`@([0-9]+|[0-9]+\.[0-9]+\.[0-9]+)$`, task.task)
  msg := "OPA-AZP-007: pipeline tasks must use governed or pinned versions"
}




