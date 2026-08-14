# organisation_policy

Organization-wide policy-as-code, security scanner rules, repository governance
metadata, and reusable CI/CD assets. GitHub Actions and the scripts in `scripts/`
form the main entry points; this repository does not contain a standalone
application runtime.

## Project Structure

```text
.
|-- .github/workflows/         # Validation and organization-wide scanning automation
|-- checkov/                   # Custom Checkov checks for Terraform, Kubernetes, and Docker
|-- config/                    # Approved tool-version configuration
|-- gitleaks/                  # Secret-detection rules and the shared Gitleaks configuration
|-- helm_chart/                # Reusable application Helm chart and example values
|-- kyverno/                   # Kubernetes admission and compliance policies
|-- metadata/                  # JSON Schema for policy metadata
|-- opa/                       # Rego policies for cloud, IaC, containers, and pipelines
|-- owners/                    # Per-policy-engine ownership metadata
|-- policy/                    # Policy documents and the exception-record schema
|-- repository/                # Repository inventory, classification, contacts, and scan exclusions
|   `-- exceptions/            # Structured repositories excluded from scanning
|-- runbook/                   # Troubleshooting guides for scan and deployment failures
|-- sample/                    # Example generated organization report
|-- scripts/                   # Scan orchestration, validation, normalization, and reporting tools
|-- semgrep/                   # Organization and language-specific Semgrep rules
|-- template/                  # Reusable scanner configurations for supported CI project types
|-- terrascan/                 # Terrascan Rego rules and metadata definitions
|-- TFLint/                    # Terraform and AWS lint rules
|-- trivy/                     # Trivy checks for containers, Kubernetes, Terraform, and vulnerabilities
|-- POLICY_INDEX.md            # Consolidated catalogue of policy IDs
|-- requirements-ci.txt        # Pinned Python dependencies used by CI
`-- SKILL.md                   # Guidance for selecting and applying this security policy pack
```

Scanner directories group rules by technology or control category. Their local
`README.md`, `POLICY_INDEX.md`, and exception directories document tool-specific
usage where present. Generated caches, cloned repositories, raw scan output, and
generated reports are intentionally omitted from the tree.

## Major Files

- `.github/workflows/syntax-and-format-check.yml` is the pull-request and push
  quality gate. It validates Python, YAML, and shell files, checks policy IDs,
  exceptions, ownership, and repository metadata, then runs Gitleaks and Checkov.
- `.github/workflows/scan_all_repo_friday_schedule.yml` is the manually triggered
  organization scan entry point. It installs the seven security tools while
  discovering approved repositories in parallel, then runs a parallel
  tool-by-repository Scan matrix before the combined Report and Mail job.
  Schedule and commit/PR triggers remain commented out.
- `scripts/get-repository-list.sh` queries the configured GitHub organization,
  applies entries from `repository/exceptions/`, and produces the repository list and
  missing-metadata inventory consumed by the scheduled workflow.
- `scripts/scan-organization.sh` is the core scan orchestrator. It clones each
  selected repository into a temporary workspace, chooses scanners based on the
  files found, uses rules from the tool directories, and writes per-repository
  results for downstream reporting.
- `scripts/install-security-tool.sh` installs one matrix-selected scanner at the
  version declared in `config/tool-versions.env`; its artifact is consumed by the
  matching `scripts/scan-security-tool.sh` matrix job. The latter clones only the
  approved repositories and writes per-tool status and log files.
- `scripts/normalize_findings.py` converts scanner reports into the shared finding
  format expected by `scripts/validate_security_controls.py`.
- `scripts/validate_security_controls.py` validates exception records against
  `policy/exception.schema.json`, rejects duplicate IDs in `POLICY_INDEX.md`, and
  blocks unexcepted critical or high normalized findings.
- `scripts/governance_check.py` enforces policy ownership, category naming,
  exception expiry, and required repository classification metadata. It links
  policy-engine directories with `owners/` and repository YAML files.
- `scripts/generate_consolidated_report.py` reads raw scan reports, applies active
  exception data through `scripts/exception_loader.py`, and creates organization
  and per-repository HTML reports, including severity and repository-total pie
  charts. `sample/organization-consolidated-sample.html` demonstrates the output.
- `scripts/generate_policy_index.py` rebuilds `POLICY_INDEX.md` from policy files;
  run it when policy metadata or rules change.
- `scripts/send_email_report.py` sends the packaged scan reports through SMTP
  SMTP as a rich HTML summary with colored tables and a severity pie chart, with
  a plain-text fallback and ZIP attachment. The workflow uses the
  `MAIL_USERNAME` Actions variable as both sender and recipient, and reads the
  authentication from Actions secrets. `SMTP_OAUTH2_TOKEN` is preferred when
  configured; `MAIL_APP_PASSWORD` is the fallback for SMTP clients without
  OAuth. The required `SMTP_SERVER`, `SMTP_PORT`, and `SMTP_SECURITY` Actions
  variables configure delivery. Set `SMTP_SECURITY` to `ssl` or `starttls` and
  `REPORT_TIMEZONE` to the timezone used in timestamped email subjects.
- `repository/classification.schema.json` defines repository inventory fields,
  while the other YAML files in `repository/` record repository ownership and
  security classification used by governance checks.
- `metadata/policy-metadata.schema.json` defines the common metadata contract for
  policy records across scanner directories.
- `config/tool-versions.env` is the single source for approved Terraform and
  scanner versions used by workflows and installer scripts. `requirements-ci.txt`
  pins shared Python validation dependencies.
- `helm_chart/Chart.yaml`, `helm_chart/values.yaml`, and `helm_chart/templates/`
  define the reusable AWS/EKS and Azure/AKS application chart; files under
  `helm_chart/examples/` provide environment-specific example values.
- `template/<type>/` contains reusable Azure Pipeline definitions, scanner
  configuration, and scan launchers for Azure, Jenkins, pipeline, Python, and
  shell projects. Start with `template/README.md` and the selected type's README.
- `SKILL.md` describes scanner selection, CI validation, release gates, and the
  remediation boundary for developers or automation working with this policy pack.
