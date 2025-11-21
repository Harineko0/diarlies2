terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.32"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create GCS bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-terraform-state"
  location      = "US"
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "terraform_state_bucket" {
  description = "GCS bucket name for Terraform state (use as TF_STATE_BUCKET variable)"
  value       = google_storage_bucket.terraform_state.name
}
