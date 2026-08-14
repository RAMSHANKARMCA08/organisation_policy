# policy id: opa-azure-pipeline-003
# reason: enforce organization security control for azure-pipeline, using OPA, pipeline scripts must not print secret variables
# severity: medium

package organization.azure_pipeline.secrets
import rego.v1
deny contains msg if {
  step := input.steps[_]
  step.script
  regex.match(`(?i)(echo|Write-Host|print).*\$\{?(password|token|secret|api[_-]?key)`, step.script)
  msg := "OPA-AZP-003: pipeline scripts must not print secret variables"
}




