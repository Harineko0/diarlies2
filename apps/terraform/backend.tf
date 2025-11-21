# Backend configuration for Terraform state storage in GCS
# This file configures remote state storage but requires runtime configuration.
#
# For local development, initialize without backend:
#   terraform init -backend=false
#
# For production deployment with remote state:
#   terraform init -backend-config="bucket=YOUR_BUCKET_NAME" -backend-config="prefix=terraform/state"
#
# The GitHub Actions workflow automatically provides these values via TF_STATE_BUCKET variable.

terraform {
  backend "gcs" {
    # Bucket name provided via -backend-config at init time
    # Prefix defaults to "terraform/state"
  }
}
