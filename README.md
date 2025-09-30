# HashiCorp Cloud Platform (HCP) Vault Implementation

## Executive Summary

This Terraform configuration provisions a production-ready HashiCorp Vault cluster on HashiCorp Cloud Platform (HCP), designed to meet enterprise security and compliance requirements. The implementation follows HashiCorp's Well-Architected Framework principles and industry best practices for secrets management infrastructure.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    HashiCorp Cloud Platform                 │
│  ┌─────────────────────────────────────────────────────────┐│
│  │                HCP Virtual Network (HVN)               ││
│  │                172.25.16.0/20                          ││
│  │  ┌───────────────────────────────────────────────────┐ ││
│  │  │              HCP Vault Cluster                    │ ││
│  │  │                                                   │ ││
│  │  │  • Managed Control Plane                         │ ││
│  │  │  • Automated Backups                             │ ││
│  │  │  • Built-in Monitoring                           │ ││
│  │  │  • Enterprise Features                           │ ││
│  │  └───────────────────────────────────────────────────┘ ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
              │
              │ API/UI Access
              │
    ┌─────────▼─────────┐
    │   Client Access   │
    │                   │
    │ • Vault CLI       │
    │ • REST API        │
    │ • Web UI          │
    │ • Applications    │
    └───────────────────┘
```

## Solution Components

### Core Infrastructure
- **HCP Virtual Network (HVN)**: Dedicated network boundary for Vault cluster
- **HCP Vault Cluster**: Fully managed Vault service with enterprise capabilities
- **Network Security**: Configurable public/private endpoint access

### Key Features
- ✅ **Zero-Touch Operations**: Fully managed by HashiCorp
- ✅ **Enterprise Ready**: Built-in compliance and security features  
- ✅ **High Availability**: Multi-AZ deployment with automated failover
- ✅ **Automated Backups**: Point-in-time recovery capabilities
- ✅ **Integrated Monitoring**: Native observability and alerting
- ✅ **Scalable Tiers**: Right-sized compute and storage options

## Prerequisites

### Required Tools
| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | >= 1.12 | Infrastructure provisioning |
| HCP CLI | Latest | Optional: Cluster management |

### HCP Account Requirements
1. **HCP Organization**: Active HashiCorp Cloud Platform account
2. **Service Principal**: Programmatic access credentials
3. **Project Access**: Contributor or Admin role assignment
4. **Billing**: Valid payment method for resource consumption

### Service Principal Setup
```bash
# Create service principal via HCP Console
# Navigate: HCP Console → Access Control (IAM) → Service Principals

# Required permissions:
# - HCP Vault: Contributor or Admin
# - HCP HVN: Contributor or Admin
```

## Configuration Management

### Environment Variables
```bash
# Required for authentication
export HCP_CLIENT_ID="your-service-principal-client-id"
export HCP_CLIENT_SECRET="your-service-principal-client-secret"
export HCP_PROJECT_ID="your-project-id"

# Optional: Override default configuration
export TF_VAR_cluster_id="production-vault"
export TF_VAR_tier="standard_small"
```

### Terraform Variables

#### Core Configuration
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `hcp_project_id` | string | "" | HCP Project identifier |
| `hcp_client_id` | string | "" | Service principal client ID |
| `hcp_client_secret` | string | "" | Service principal secret |

#### Network Configuration
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `hvn_id` | string | "main-hvn" | HVN identifier |
| `cloud_provider` | string | "aws" | Target cloud provider |
| `region` | string | "ap-southeast-1" | Deployment region |
| `cidr_block` | string | "172.25.16.0/20" | HVN network range |

#### Vault Cluster Configuration
| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cluster_id` | string | "aws-hcp-vault-cluster" | Vault cluster identifier |
| `tier` | string | "dev" | Cluster performance tier |
| `public_endpoint` | bool | true | Enable public API access |

### Tier Selection Guide

| Tier | Use Case | Features | Recommended For |
|------|----------|----------|-----------------|
| `dev` | Development/Testing | Basic functionality | Non-production environments |
| `starter_small` | Small Production | Dedicated infrastructure | Small-scale production |
| `standard_small` | Production | Enhanced performance | Medium-scale production |
| `standard_medium` | Production | Higher throughput | Large-scale production |
| `standard_large` | Enterprise | Maximum performance | High-volume enterprise |
| `plus_small` | Compliance | Advanced features | Regulated industries |
| `plus_medium` | Enterprise Compliance | Full feature set | Large regulated workloads |
| `plus_large` | Enterprise Scale | Maximum capabilities | Enterprise-wide deployment |

## Deployment Procedures

### Initial Deployment
```bash
# 1. Clone and navigate to project
cd hcp-vault-sep2025

# 2. Initialize Terraform
terraform init

# 3. Create configuration file
cp terraform.tfvars.example terraform.tfvars

# 4. Customize deployment parameters
vim terraform.tfvars

# 5. Validate configuration
terraform validate
terraform fmt

# 6. Review planned changes
terraform plan

# 7. Deploy infrastructure
terraform apply
```

### Configuration Validation
```bash
# Verify Terraform syntax
terraform validate

# Check formatting compliance
terraform fmt -check

# Security scan (if using external tools)
# tfsec .
# checkov -f main.tf
```

### Post-Deployment Verification
```bash
# Retrieve cluster information
terraform output vault_public_endpoint
terraform output vault_namespace

# Verify cluster accessibility
export VAULT_ADDR=$(terraform output -raw vault_public_endpoint)
export VAULT_NAMESPACE=$(terraform output -raw vault_namespace)
vault status
```

## Operations Guide

### Day 1 Operations (Initial Setup)

#### 1. Authentication Configuration
```bash
# Configure initial admin access
export VAULT_TOKEN=$(terraform output -raw vault_admin_token)

# Enable authentication methods
vault auth enable userpass
vault auth enable ldap
vault auth enable oidc
```

#### 2. Policy Framework
```bash
# Create base policies
vault policy write admin-policy - <<EOF
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

vault policy write developer-policy - <<EOF
path "secret/data/dev/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
```

#### 3. Secrets Engine Configuration
```bash
# Enable KV v2 secrets engine
vault secrets enable -path=secret kv-v2

# Enable database secrets engine
vault secrets enable database

# Enable PKI for certificate management
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
```

### Day 2+ Operations (Ongoing Management)

#### Monitoring and Alerting
- **Native Monitoring**: HCP provides built-in metrics and alerting
- **External Integration**: Configure with Datadog, Splunk, or Grafana
- **Health Checks**: Automated cluster health monitoring

#### Backup and Recovery
- **Automated Snapshots**: Managed by HCP infrastructure
- **Point-in-Time Recovery**: Available through HCP console
- **Disaster Recovery**: Cross-region replication available

#### Security Operations
```bash
# Regular security tasks
vault audit enable file file_path=/vault/logs/audit.log

# Token lifecycle management
vault token create -policy=developer-policy -ttl=8h

# Secret rotation workflows
vault write database/rotate-root/my-database
```

## Security Considerations

### Network Security
- **Private Endpoints**: Recommended for production workloads
- **CIDR Planning**: Avoid conflicts with existing network ranges
- **Firewall Rules**: Implement appropriate access controls

### Access Control
- **Principle of Least Privilege**: Grant minimum required permissions
- **Regular Access Reviews**: Quarterly policy and access audits
- **Multi-Factor Authentication**: Enable for all human users

### Compliance Framework
- **SOC 2 Type II**: Built-in compliance for HCP infrastructure
- **HIPAA**: Available with appropriate configuration
- **PCI DSS**: Supported for payment card data protection
- **FedRAMP**: Available in select regions

## Troubleshooting Guide

### Common Issues

#### Authentication Failures
```bash
# Verify credentials
env | grep HCP_

# Test API connectivity
curl -H "Authorization: Bearer $HCP_CLIENT_SECRET" \
  https://api.cloud.hashicorp.com/2019-12-10/projects
```

#### Network Connectivity
```bash
# Verify HVN status
terraform refresh
terraform show | grep -A 10 hcp_hvn

# Test cluster accessibility
nc -zv <vault-endpoint> 8200
```

#### Resource Limits
- **HCP Quotas**: Check organization resource limits
- **Regional Availability**: Verify service availability in target region
- **Tier Limitations**: Ensure selected tier meets requirements

### Support Escalation
1. **Internal Documentation**: Check runbooks and procedures
2. **HashiCorp Support**: Submit ticket through HCP console
3. **Professional Services**: Engage for complex implementations
4. **Community Resources**: HashiCorp Learn and forums

## Cost Optimization

### Resource Right-Sizing
- **Development**: Use `dev` tier for non-production
- **Production**: Start with `starter_small` and scale as needed
- **Monitoring**: Regular usage analysis and tier optimization

### Cost Management
- **Resource Tagging**: Implement consistent tagging strategy
- **Budget Alerts**: Configure spending notifications
- **Regular Reviews**: Monthly cost and usage analysis

## Maintenance Procedures

### Upgrade Management
- **Automatic Updates**: Managed by HCP platform
- **Maintenance Windows**: Configure during low-usage periods
- **Change Management**: Follow organizational change control processes

### Regular Maintenance Tasks
- [ ] Monthly security patching (automated)
- [ ] Quarterly access review
- [ ] Semi-annual disaster recovery testing
- [ ] Annual compliance audit

## Implementation Checklist

### Pre-Deployment
- [ ] HCP account and project setup
- [ ] Service principal creation and testing
- [ ] Network architecture review
- [ ] Security policy approval
- [ ] Change management approval

### Deployment
- [ ] Terraform code review
- [ ] Security scan completion
- [ ] Deployment testing in non-production
- [ ] Production deployment
- [ ] Post-deployment verification

### Post-Deployment
- [ ] Authentication method configuration
- [ ] Policy framework implementation
- [ ] Secrets engine setup
- [ ] Monitoring and alerting configuration
- [ ] Documentation update
- [ ] Team training and handover

---
**Document Version**: 1.0  
**Last Updated**: September 2025  
**Next Review**: December 2025