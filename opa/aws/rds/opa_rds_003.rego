# policy id: opa-rds-003
# reason: enforce organization security control for rds, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.rds

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_db_instance"
  rc.change.after.backup_retention_period < 7
  msg := sprintf("OPA-AWS-RDS-003: %s must retain backups for at least seven days", [rc.address])
}





