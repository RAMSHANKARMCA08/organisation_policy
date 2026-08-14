# policy id: ckv-org-019
# reason: enforce organization security control for kubernetes, using Checkov, apply the approved resource security condition
# severity: high

from checkov.common.checks.base_resource_check import BaseResourceCheck


class OrganizationCheck019(BaseResourceCheck):
    def __init__(self):
        super().__init__(
            name="Organization kubernetes control 019",
            id="CKV_ORG_019",
            supported_resources=["*"],
            categories=["kubernetes", "security"],
        )

    def scan_resource_conf(self, conf):
        # Replace this deterministic placeholder with the approved resource attribute check.
        return conf is not None


check = OrganizationCheck019()
checkov_check = check
