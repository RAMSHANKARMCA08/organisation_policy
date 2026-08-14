# policy id: opa-shell-001
# reason: enforce organization security control for shell, using OPA, remote content must not be piped directly to a shell
# severity: medium

package organization.shell

import rego.v1

deny contains msg if {
  regex.match(`(?i)(curl|wget)[^\n]*\|\s*(ba)?sh`, input.content)
  msg := "OPA-SHELL-001: remote content must not be piped directly to a shell"
}





