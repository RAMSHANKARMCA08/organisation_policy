# policy id: opa-azure-pipeline-008
# reason: enforce organization security control for azure-pipeline, using OPA, ensure no latest image is used
# severity: high

package organization.azure_pipeline.agents

import rego.v1

approved_vm_images := {"ubuntu-latest", "ubuntu-22.04", "windows-latest"}
approved_pools := {"approved-linux-agents", "approved-windows-agents"}

deny contains msg if {
  pool := object.get(input, "pool", {})
  image := object.get(pool, "vmImage", "")
  name := object.get(pool, "name", "")
  not image in approved_vm_images
  not name in approved_pools
  msg := "opa-azurepipeline-008: pipeline must use an approved hosted image or self-hosted pool"
}



