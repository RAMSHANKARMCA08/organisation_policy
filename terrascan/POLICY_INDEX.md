# terrascan sample policy index

These 30 policies use terrascan custom Rego plus companion JSON metadata. They are representative samples and must be tested against the installed terrascan version before production use.

| Policy ID | Category | Folder | Severity | Resource | Description | Status |
|---|---|---|---|---|---|---|
| terrascan-aws-001 | aws | s3 | high | aws_s3_bucket | S3 buckets must not allow public ACLs | active |
| terrascan-aws-002 | aws | s3 | high | aws_s3_bucket | S3 buckets must enable versioning | active |
| terrascan-aws-003 | aws | s3 | high | aws_s3_bucket_server_side_encryption_configuration | S3 buckets must use server-side encryption | active |
| terrascan-aws-004 | aws | ec2 | critical | aws_security_group_rule | Security groups must not expose SSH to the internet | active |
| terrascan-aws-005 | aws | ec2 | high | aws_instance | EC2 instances must require IMDSv2 | active |
| terrascan-aws-006 | aws | ec2 | high | aws_ebs_volume | EBS volumes must be encrypted | active |
| terrascan-aws-007 | aws | iam | critical | aws_iam_policy | IAM policies must not allow wildcard actions | active |
| terrascan-aws-008 | aws | rds | critical | aws_db_instance | RDS instances must not be publicly accessible | active |
| terrascan-aws-009 | aws | rds | high | aws_db_instance | RDS storage must be encrypted | active |
| terrascan-aws-010 | aws | rds | high | aws_db_instance | RDS must retain backups | active |
| terrascan-aws-011 | aws | cloudtrail | high | aws_cloudtrail | CloudTrail must validate log files | active |
| terrascan-aws-012 | aws | cloudtrail | high | aws_cloudtrail | CloudTrail must be multi-region | active |
| terrascan-azure-013 | azure | storage | high | azurerm_storage_account | Azure storage must require TLS 1.2 | active |
| terrascan-azure-014 | azure | storage | high | azurerm_storage_account | Azure storage must disable public access | active |
| terrascan-azure-015 | azure | sql | critical | azurerm_mssql_server | Azure SQL must disable public network access | active |
| terrascan-azure-016 | azure | sql | high | azurerm_mssql_server | Azure SQL must require TLS 1.2 | active |
| terrascan-azure-017 | azure | keyvault | high | azurerm_key_vault | Key Vault must enable purge protection | active |
| terrascan-azure-018 | azure | network | critical | azurerm_network_security_rule | Azure network rules must not expose RDP to the internet | active |
| terrascan-kubernetes-019 | kubernetes | podsecurity | critical | kubernetes_pod | Kubernetes pods must not be privileged | active |
| terrascan-kubernetes-020 | kubernetes | podsecurity | high | kubernetes_pod | Kubernetes pods should run as non-root | active |
| terrascan-kubernetes-021 | kubernetes | network | high | kubernetes_service | Kubernetes services should not use unrestricted LoadBalancer exposure | active |
| terrascan-kubernetes-022 | kubernetes | resources | medium | kubernetes_deployment | Kubernetes deployments must define resource limits | active |
| terrascan-kubernetes-023 | kubernetes | network | high | kubernetes_ingress | Kubernetes ingress must configure TLS | active |
| terrascan-kubernetes-024 | kubernetes | identity | high | kubernetes_role_binding | Kubernetes role bindings must avoid cluster-admin | active |
| terrascan-docker-025 | docker | image | high | docker_image | Docker images must use approved immutable tags | active |
| terrascan-docker-026 | docker | runtime | critical | docker_container | Docker containers must not run privileged | active |
| terrascan-docker-027 | docker | runtime | high | docker_container | Docker containers should run as non-root | active |
| terrascan-gcp-028 | gcp | storage | high | google_storage_bucket | GCP storage buckets must not be publicly readable | active |
| terrascan-gcp-029 | gcp | compute | critical | google_compute_firewall | GCP firewalls must not expose SSH to the internet | active |
| terrascan-gcp-030 | gcp | sql | high | google_sql_database_instance | GCP SQL instances must require SSL | active |

critical and high findings block by default; exceptions require external approval.




