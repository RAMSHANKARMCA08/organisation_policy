# Reusable Helm chart

This is one chart for app1, app2, and app3 across dev, stage, and prod on AWS or Azure. Application, environment, and cloud differences are values, not duplicated templates.

## Usage

```text
helm lint helm_chart
helm template app1-dev helm_chart -f helm_chart/examples/app1-dev-aws.yaml
helm upgrade --install app1-prod ./helm_chart -f ./helm_chart/examples/app1-prod-azure.yaml
```

The chart generates names such as `app1-dev` and labels for application, instance, environment, and cloud. AWS IRSA and Azure Workload Identity annotations are optional values. Examples contain placeholders only; never commit credentials, account IDs, tenant IDs, or real role/client identifiers.

## Configuration

Use `application.name` (`app1`, `app2`, `app3`), `environment.name` (`dev`, `stage`, `prod`), and `cloud.provider` (`aws`, `azure`). Generic Kubernetes settings remain cloud-neutral; provider-specific annotations, selectors, and tolerations live under `cloud.aws` or `cloud.azure`.


Security toolchain: Gitleaks scans secrets and Checkov scans infrastructure-as-code. Both use pinned CI versions, normalized findings, and the shared exception/release-gate process.

