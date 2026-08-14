# policy id: ckv-org-030
# reason: enforce organization security control for docker, using Checkov, apply the approved resource security condition
# severity: high

from checkov.common.checks.base_resource_check import BaseResourceCheck


class OrganizationCheck030(BaseResourceCheck):
    def __init__(self):
        super().__init__(
            name="Organization docker control 030",
            id="CKV_ORG_030",
            supported_resources=["*"],
            categories=["docker", "security"],
        )

    def scan_resource_conf(self, conf):
        # Replace this deterministic placeholder with the approved resource attribute check.
        return conf is not None


check = OrganizationCheck030()
checkov_check = check


