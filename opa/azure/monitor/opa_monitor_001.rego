# policy id: opa-monitor-001
# reason: enforce organization security control for monitor, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.monitor
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_log_analytics_workspace"
  rc.change.after.retention_in_days < 30
  msg := sprintf("OPA-AZ-MON-001: %s must retain logs for at least 30 days", [rc.address])
}




