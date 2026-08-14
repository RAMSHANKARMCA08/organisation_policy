# policy id: opa-eks-001
# reason: enforce organization security control for eks, using OPA, policy requirements are satisfied
# severity: medium

package organization.aws.eks
import rego.v1
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_eks_cluster"
  rc.change.after.endpoint_public_access == true
  msg := sprintf("OPA-AWS-EKS-001: %s must not expose the public API endpoint", [rc.address])
}




