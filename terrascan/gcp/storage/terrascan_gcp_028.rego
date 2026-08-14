# policy id: terrascan-gcp-028
# reason: enforce organization security control for gcp, using Terrascan, policy requirements are satisfied
# severity: medium

package organization.terrascan.gcp.storage

terrascan_gcp_028[resource.id] {
  resource := input.google_storage_bucket[_]
  resource.config.uniform_bucket_level_access == false
  result := {
    "msg": "GCP storage buckets must not be publicly readable",
    `"resource`": resource.id,
  }
  terrascan_gcp_028[resource.id] = result
}




