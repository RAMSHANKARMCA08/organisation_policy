# policy id: terrascan-gcp-029
# reason: enforce organization security control for gcp, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.gcp.compute

terrascan_gcp_029[resource.id] {
  resource := input.google_compute_firewall[_]
  resource.config.source_ranges[_] == "0.0.0.0/0"; resource.config.allow[_].ports[_] == "22"
  result := {
    "msg": "GCP firewalls must not expose SSH to the internet",
    `"resource`": resource.id,
  }
  terrascan_gcp_029[resource.id] = result
}




