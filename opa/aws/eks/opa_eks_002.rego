# policy id: opa-eks-002
# reason: enforce organization security control for eks, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.eks

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_eks_cluster"
  required := {"api", "audit", "authenticator", "controllerManager", "scheduler"}
  configured := {log | log := rc.change.after.enabled_cluster_log_types[_]}
  missing := required - configured
  count(missing) > 0
  msg := sprintf("OPA-AWS-EKS-002: %s is missing control-plane logs: %v", [rc.address, missing])
}





