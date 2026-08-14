# policy id: opa-jenkins-001
# reason: enforce organization security control for jenkins, using OPA, Jenkins must use an approved agent label
# severity: medium

package organization.jenkins.agents

import rego.v1

approved_agents := {"approved-linux-agent", "approved-windows-agent"}

deny contains msg if {
  agent := object.get(input, "agent", "")
  agent != ""
  agent != "none"
  agent != "any"
  not agent in approved_agents
  msg := "opa-jenkins-001: Jenkins must use an approved agent label"
}

deny contains msg if {
  object.get(input, "agent", "") in {"", "any"}
  msg := "opa-jenkins-001: unrestricted Jenkins agents are not allowed"
}




