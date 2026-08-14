# policy id: opa-python-001
# reason: enforce organization security control for python, using OPA, disabling TLS verification is prohibited
# severity: medium

package organization.python

import rego.v1

deny contains msg if {
  regex.match(`(?m)verify\s*=\s*False`, input.content)
  msg := "OPA-PY-001: disabling TLS verification is prohibited"
}





