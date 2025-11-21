output "network_name" {
  description = "VPC network name."
  value       = google_compute_network.diarlies.name
}

output "subnet_name" {
  description = "Primary subnet."
  value       = google_compute_subnetwork.diarlies_primary.name
}
