# policy id: opa-kubernetes-011
# reason: enforce organization security control for kubernetes, using OPA, ensure no latest image is used
# severity: high

package organization.kubernetes

import rego.v1

# severity: high
deny contains msg if {
  image := input.spec.template.spec.containers[_].image
  endswith(lower(image), ":latest")
  msg := "opa-kubernetes-011: Kubernetes workloads must not deploy the latest image tag"
}

deny contains msg if {
  image := input.spec.containers[_].image
  endswith(lower(image), ":latest")
  msg := "opa-kubernetes-011: Kubernetes pods must not deploy the latest image tag"
}



