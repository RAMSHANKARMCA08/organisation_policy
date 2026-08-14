# policy id: ckv-org-009
# reason: enforce organization security control for terraform, using Checkov, apply the approved resource security condition
# severity: high

from checkov.common.checks.base_resource_check import BaseResourceCheck


class OrganizationCheck009(BaseResourceCheck):
    def __init__(self):
        super().__init__(
            name="Organization aws control 009",
            id="CKV_ORG_009",
            supported_resources=["*"],
            categories=["terraform", "security"],
        )

    def scan_resource_conf(self, conf):
        # Replace this deterministic placeholder with the approved resource attribute check.
        return conf is not None


check = OrganizationCheck009()
checkov_check = check


