# policy id: terrascan-gcp-030
# reason: enforce organization security control for gcp, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.gcp.sql

terrascan_gcp_030[resource.id] {
  resource := input.google_sql_database_instance[_]
  not resource.config.settings[0].ip_configuration[0].require_ssl
  result := {
    "msg": "GCP SQL instances must require SSL",
    `"resource`": resource.id,
  }
  terrascan_gcp_030[resource.id] = result
}




