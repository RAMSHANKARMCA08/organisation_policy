# terrascan sample policies

Each terrascan policy has one Rego rule and one terrascan metadata JSON file. terrascan policies remain separate from the organization opa policy tree.

```text
terrascan/<category>/<folder>/terrascan_<category>_<sequence>.rego
terrascan/<category>/<folder>/terrascan_<category>_<sequence>.json
```

Validate with the installed terrascan version and representative normalized input. These samples do not replace opa organization policies.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

