# tflint policy rules

This folder contains 30 individually reviewable native tflint configuration fragments. Each fragment enables one rule and follows policy/naming_convention.md.

## Native syntax

tflint loads rule blocks from its HCL configuration; it does not discover arbitrary files in subfolders. These files are one-rule fragments for review and policy indexing. Approved fragments must be copied into .tflint.hcl or generated into an aggregate file before scanning.

```text
tflint --init --config tflint/.tflint.hcl
tflint --config tflint/.tflint.hcl --recursive --format compact path/to/repository
```

The AWS rules require the pinned AWS ruleset plugin. Severity is organizational metadata in POLICY_INDEX.md. Findings block the gate unless an unexpired repository-specific exception matches the exact policy ID.

## Structure

- terraform/language: syntax and language checks
- terraform/module: module source, version, and structure checks
- terraform/quality: documentation and unused declaration checks
- terraform/style: naming and comment checks
- aws: provider-specific fragments grouped by service concern
- exceptions: repository-scoped exception records

Use opa/Conftest, terrascan, Checkov, trivy, and semgrep for controls outside tflint's Terraform linting boundary.

Validate that exactly 30 fragments exist, filenames are lowercase tflint_<category>_<sequence>.hcl, and every rule is supported by the installed ruleset.

CI records TFLint output in the shared finding format and runs `scripts/validate_security_controls.py --findings normalized-findings.json` before release.


