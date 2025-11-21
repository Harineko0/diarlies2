# Terraform Bootstrap

This directory contains the initial Terraform configuration to create the GCS bucket for storing Terraform state. This must be run **once** before using the main Terraform configuration with remote state.

## Prerequisites

- GCP project created
- `gcloud` CLI authenticated with sufficient permissions
- Terraform installed

## Steps

1. **Set your project ID**:
   ```bash
   export TF_VAR_project_id="your-gcp-project-id"
   ```

2. **Initialize and apply**:
   ```bash
   cd apps/terraform/bootstrap
   terraform init
   terraform apply
   ```

3. **Note the bucket name** from the output - you'll need it for:
   - GitHub Actions variable `TF_STATE_BUCKET`
   - Local Terraform init: `terraform init -backend-config="bucket=BUCKET_NAME"`

4. **Migrate local state** (if you already ran terraform in the parent directory):
   ```bash
   cd ..
   terraform init -backend-config="bucket=BUCKET_NAME" -backend-config="prefix=terraform/state" -migrate-state
   ```

## What This Creates

- GCS bucket for Terraform state with:
  - Versioning enabled
  - Uniform bucket-level access
  - Location set to `US`
  - Force destroy disabled (for safety)
