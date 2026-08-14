# policy id: ckv-org-024
# reason: enforce organization security control for kubernetes, using Checkov, apply the approved resource security condition
# severity: high

from checkov.common.checks.base_resource_check import BaseResourceCheck


class OrganizationCheck024(BaseResourceCheck):
    def __init__(self):
        super().__init__(
            name="Organization kubernetes control 024",
            id="CKV_ORG_024",
            supported_resources=["*"],
            categories=["kubernetes", "security"],
        )

    def scan_resource_conf(self, conf):
        # Replace this deterministic placeholder with the approved resource attribute check.
        return conf is not None


check = OrganizationCheck024()
checkov_check = check


