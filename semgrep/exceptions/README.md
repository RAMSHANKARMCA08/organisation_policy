# semgrep exceptions

Store records under `exceptions/<repository-name>/<policy-id>.yaml`. Required fields are `repository`, `policy_id`, `reason`, `initiated_by`, `approved_by`, `valid_till`, `status`, and `reference`. Only an exact repository/policy match with `status: approved` and an unexpired `valid_till` may be excluded from blocking and consolidated reports. Pending or expired records remain findings.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

