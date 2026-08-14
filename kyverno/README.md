# Kyverno policy catalogue

This folder contains 30 standalone Kyverno `ClusterPolicy` resources. Each file has one rule, one stable lowercase filename, and one organizational policy entry.

## Structure

Policies are grouped as `kyverno/<category>/<folder>/kyverno_kubernetes_<sequence>.yaml`:

- `podsecurity`: workload hardening, identity, and resource controls
- `network`: isolation, ingress TLS, and service exposure
- `registry`: image provenance, tags, digests, and pull policy
- `compliance`: labels, availability, storage, and encryption metadata

## Usage

```text
kubectl apply --dry-run=server -f kyverno/<category>/<folder>/kyverno_kubernetes_001.yaml
kyverno apply kyverno/podsecurity --resource manifests/
```

Policies use native Kyverno `ClusterPolicy` syntax with `validationFailureAction: Enforce`. Review each policy against the cluster version and enabled Kyverno features before deployment. Critical and high findings block release unless an approved, unexpired repository exception exists.

Severity, policy IDs, ownership, and status are maintained in `POLICY_INDEX.md`. The canonical naming rules are in `policy/naming_convention.md`.

## Validation

The catalogue must contain exactly 30 YAML policy files, each with one `ClusterPolicy` and one rule. Validate syntax with `kyverno apply` or server-side Kubernetes dry-run before promotion.

CI normalizes Kyverno findings with `scripts/normalize_findings.py` and applies the shared critical/high release gate. Exceptions must pass `policy/exception.schema.json` validation.


Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

