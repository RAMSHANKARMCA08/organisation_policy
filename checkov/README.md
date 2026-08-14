# Checkov custom check catalogue

This folder contains exactly 30 native Checkov custom-check Python modules. Checkov custom checks are Python classes derived from `BaseResourceCheck`; they are not Rego, Semgrep YAML, or arbitrary metadata files.

## Structure

```text
checkov/<category>/<folder>/checkov_<category>_<sequence>.py
```

Categories cover Terraform/AWS, Terraform/Azure, Kubernetes pod security, and Docker security. Each module has one stable `CKV_ORG_<sequence>` identifier. Load approved modules through Checkov's custom checks mechanism and run `checkov -d <repository> --output json`.

The modules are intentionally small reusable templates. Before production enablement, replace the documented check body with the approved resource-specific condition and set concrete `supported_resources`; Checkov does not support arbitrary wildcard resource semantics as a substitute for a real check.

## Validation and governance

Run the pinned Checkov version from `requirements-ci.txt`. Normalize JSON findings with `scripts/normalize_findings.py`; critical and high findings block unless an approved, unexpired exception matches the repository and `CKV_ORG_<sequence>` policy ID. Keep exceptions under `checkov/exceptions/`.
