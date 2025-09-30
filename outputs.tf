# HVN Outputs
output "hvn_id" {
  description = "The ID of the HCP HVN"
  value       = hcp_hvn.aws_hcp_vault_hvn.hvn_id
}

output "hvn_cidr_block" {
  description = "The CIDR block of the HCP HVN"
  value       = hcp_hvn.aws_hcp_vault_hvn.cidr_block
}

output "hvn_region" {
  description = "The region of the HCP HVN"
  value       = hcp_hvn.aws_hcp_vault_hvn.region
}

output "hvn_cloud_provider" {
  description = "The cloud provider of the HCP HVN"
  value       = hcp_hvn.aws_hcp_vault_hvn.cloud_provider
}

output "hvn_provider_account_id" {
  description = "The provider account ID where the HVN is located"
  value       = hcp_hvn.aws_hcp_vault_hvn.provider_account_id
}

output "hvn_self_link" {
  description = "A unique URL identifying the HVN"
  value       = hcp_hvn.aws_hcp_vault_hvn.self_link
}

# Vault Cluster Outputs
output "vault_cluster_id" {
  description = "The ID of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.cluster_id
}

output "vault_public_endpoint_url" {
  description = "The public endpoint URL of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.vault_public_endpoint_url
}

output "vault_private_endpoint_url" {
  description = "The private endpoint URL of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.vault_private_endpoint_url
}

output "vault_version" {
  description = "The current Vault version of the cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.vault_version
}

output "vault_tier" {
  description = "Tier of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.tier
}

output "vault_organization_id" {
  description = "The ID of the organization this HCP Vault cluster is located in"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.organization_id
}

output "vault_project_id" {
  description = "The ID of the project this HCP Vault cluster is located in"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.project_id
}

output "vault_namespace" {
  description = "The namespace of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.namespace
}

output "vault_self_link" {
  description = "A unique URL identifying the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.self_link
}

output "vault_state" {
  description = "The state of the HCP Vault cluster"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.state
}

output "vault_created_at" {
  description = "The time that the HCP Vault cluster was created"
  value       = hcp_vault_cluster.aws_hcp_vault_cluster.created_at
}

# Connection Information (Formatted for easy use)
output "vault_connection_info" {
  description = "Formatted connection information for the Vault cluster"
  value = {
    vault_addr      = hcp_vault_cluster.aws_hcp_vault_cluster.vault_public_endpoint_url
    vault_namespace = hcp_vault_cluster.aws_hcp_vault_cluster.namespace
    cluster_id      = hcp_vault_cluster.aws_hcp_vault_cluster.cluster_id
    region          = hcp_hvn.aws_hcp_vault_hvn.region
  }
}

# CLI Commands (for easy copy-paste)
output "vault_cli_commands" {
  description = "Ready-to-use Vault CLI commands"
  value = {
    export_vault_addr = "export VAULT_ADDR=${hcp_vault_cluster.aws_hcp_vault_cluster.vault_public_endpoint_url}"
    export_vault_namespace = "export VAULT_NAMESPACE=${hcp_vault_cluster.aws_hcp_vault_cluster.namespace}"
    vault_status = "vault status"
    vault_auth_help = "vault auth -method=userpass username=<your-username>"
  }
}

# Network Information
output "network_info" {
  description = "Network configuration details"
  value = {
    hvn_id              = hcp_hvn.aws_hcp_vault_hvn.hvn_id
    hvn_cidr            = hcp_hvn.aws_hcp_vault_hvn.cidr_block
    cloud_provider      = hcp_hvn.aws_hcp_vault_hvn.cloud_provider
    region              = hcp_hvn.aws_hcp_vault_hvn.region
    provider_account_id = hcp_hvn.aws_hcp_vault_hvn.provider_account_id
  }
}