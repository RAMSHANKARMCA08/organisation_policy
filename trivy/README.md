# trivy security policy pack

trivy provides built-in vulnerability, secret, misconfiguration, license, and SBOM capabilities. This pack records 30 organization controls and maps each to the supported trivy scan mode. It does not invent unsupported trivy rule syntax.

## Usage

```text
trivy fs --scanners vuln,misconfig,secret --severity high,critical --format json --output trivy-report.json <repository>
trivy config --severity high,critical <repository>
trivy image --severity high,critical <image>
```

Use `POLICY_INDEX.md` to select relevant controls. opa/Conftest remains the organization infrastructure-policy gate; semgrep remains SAST; Gitleaks remains dedicated repository secret scanning.

The organization scan also runs `trivy fs --scanners vuln` for dependency vulnerabilities, including Log4j/Log4Shell detection. Critical and high findings block release unless an approved, unexpired exception exists.
| Policy ID | Category | Severity | Description | Implementation | Status |
|---|---|---|---|---|---|



