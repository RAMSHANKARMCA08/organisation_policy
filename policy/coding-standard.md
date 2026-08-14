# Sample coding standard

Status: SAMPLE — requires engineering and security-owner approval.

1. Validate untrusted input at every trust boundary.
2. Use parameterized queries and safe framework APIs.
3. Avoid dynamic evaluation and unsafe deserialization.
4. Do not construct shell commands from untrusted input.
5. Keep TLS certificate verification enabled.
6. Use cryptographic libraries and approved algorithms rather than custom cryptography.
7. Use secure temporary-file APIs and restrictive permissions.
8. Never hard-code secrets or log sensitive values.
9. Pin and review dependencies; remove unused packages.
10. Handle errors without exposing internals or credentials.
11. Add tests for authentication, authorization, validation, and failure paths.
12. Keep changes small, reviewable, formatted, and covered by linting.
13. Follow language-specific semgrep and static-analysis rules.
14. Document security-sensitive design decisions.
15. Review this sample against the current organization standard before adoption.


