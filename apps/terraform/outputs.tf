output "network_name" {
  description = "VPC network name."
  value       = google_compute_network.diarlies.name
}

output "subnet_name" {
  description = "Primary subnet."
  value       = google_compute_subnetwork.diarlies_primary.name
}

output "workload_identity_provider" {
  description = "Workload Identity Provider for GitHub Actions (use as GCP_WORKLOAD_IDENTITY_PROVIDER variable)."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "github_actions_service_account" {
  description = "Service Account email for GitHub Actions (use as GCP_SERVICE_ACCOUNT variable)."
  value       = google_service_account.github_actions.email
}
