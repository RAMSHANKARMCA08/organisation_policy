# policy id: opa-eks-003
# reason: enforce organization security control for eks, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.eks

import rego.v1

deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_eks_cluster"
  count(rc.change.after.encryption_config) == 0
  msg := sprintf("OPA-AWS-EKS-003: %s must encrypt Kubernetes secrets with KMS", [rc.address])
}





