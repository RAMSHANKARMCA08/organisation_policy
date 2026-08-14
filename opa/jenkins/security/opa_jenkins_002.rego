# policy id: opa-jenkins-002
# reason: enforce organization security control for jenkins, using OPA, Jenkins must contain an enabled code scanning stage
# severity: medium

package organization.jenkins.security

import rego.v1

deny contains msg if {
  stages := object.get(input, "stages", [])
  not some stage in stages {
    lower(object.get(stage, "name", "")) in {"scan code", "scan", "security", "semgrep", "security scan"}
  }
  msg := "opa-jenkins-002: Jenkins must contain an enabled code scanning stage"
}




