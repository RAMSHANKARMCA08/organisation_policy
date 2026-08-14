# policy id: opa-rds-001
# reason: enforce organization security control for rds, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.rds
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type in {"aws_db_instance", "aws_rds_cluster"}
  rc.change.after.publicly_accessible == true
  msg := sprintf("OPA-AWS-RDS-001: %s must not be publicly accessible", [rc.address])
}




