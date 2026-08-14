# policy id: ckv-org-023
# reason: enforce organization security control for kubernetes, using Checkov, apply the approved resource security condition
# severity: high

from checkov.common.checks.base_resource_check import BaseResourceCheck


class OrganizationCheck023(BaseResourceCheck):
    def __init__(self):
        super().__init__(
            name="Organization kubernetes control 023",
            id="CKV_ORG_023",
            supported_resources=["*"],
            categories=["kubernetes", "security"],
        )

    def scan_resource_conf(self, conf):
        # Replace this deterministic placeholder with the approved resource attribute check.
        return conf is not None


check = OrganizationCheck023()
checkov_check = check


