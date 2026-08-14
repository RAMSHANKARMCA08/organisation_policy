# terrascan exceptions

Store records under `exceptions/<repository-name>/<policy-id>.yaml`. Only an exact repository/policy match with approved status and a future `valid_till` may be excluded from blocking and consolidated reports.




Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

