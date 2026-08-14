# policy id: opa-rds-004
# reason: enforce organization security control for rds, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.rds

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type in {"aws_db_instance", "aws_rds_cluster"}
  not rc.change.after.deletion_protection == true
  msg := sprintf("OPA-AWS-RDS-004: %s must enable deletion protection", [rc.address])
}





