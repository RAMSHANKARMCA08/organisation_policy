# policy id: opa-monitor-002
# reason: enforce organization security control for monitor, using OPA, policy requirements are satisfied
# severity: medium

package organization.azure.monitor

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "azurerm_monitor_diagnostic_setting"
  count(rc.change.after.enabled_log) == 0
  count(rc.change.after.log) == 0
  msg := sprintf("OPA-AZ-MON-002: %s must enable diagnostic logs", [rc.address])
}





