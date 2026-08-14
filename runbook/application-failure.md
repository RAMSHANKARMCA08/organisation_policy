# Application failure

1. Capture the version, environment, time window, health state, and sanitized logs/metrics/traces.
2. Reproduce safely outside production when possible and identify the smallest failing boundary.
3. Check configuration provenance, dependency changes, resource constraints, and recent releases.
4. Do not log secrets, tokens, private data, or connection strings.
5. Apply the smallest reviewed remediation and add a regression test.
6. Re-run build, test, SAST, dependency, and deployment health gates.


