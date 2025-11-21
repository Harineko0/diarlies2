terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.12"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Core networking placeholder; extend as services are defined.
resource "google_compute_network" "diarlies" {
  name                    = "${var.app_name}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "diarlies_primary" {
  name          = "${var.app_name}-primary"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.diarlies.id
}
