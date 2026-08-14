# Gitleaks rule catalogue

This folder contains exactly 30 standalone native Gitleaks TOML rule fragments. Each file contains one `[[rules]]` entry and follows `gitleaks/<category>/<folder>/gitleaks_<category>_<sequence>.toml`.

Gitleaks supports TOML rule fields such as `id`, `description`, `regex`, `secretGroup`, `keywords`, and `tags`. Combine approved fragments into the CI configuration before scanning. Use Gitleaks for secrets; do not replace it with Semgrep.
