# Task 04: Complete Terraform Infrastructure Configuration

Metadata:
- Phase: 1 (Infrastructure Foundation)
- Dependencies: Tasks 01, 02, 03 → All infrastructure definitions
- Provides:
  - Complete Terraform configuration
  - VPC network
  - VPC connector for Cloud Run
- Size: Medium (3 files)
- Verification: L3 (Build/Deploy Success)

## Implementation Content
Integrate all infrastructure components (network, Cloud SQL, Storage) into a complete Terraform configuration with VPC networking for Cloud Run to Cloud SQL connectivity.

## Target Files
- [ ] `apps/terraform/network.tf`
- [ ] `apps/terraform/outputs.tf`
- [ ] `apps/terraform/main.tf` (update)

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review all infrastructure requirements from design docs
- [ ] Verify Tasks 01-03 configurations
- [ ] Document network topology requirements

### 2. Green Phase
- [ ] Create `apps/terraform/network.tf`:
  ```hcl
  resource "google_compute_network" "main" {
    name                    = "diarlies-network"
    auto_create_subnetworks = false
  }

  resource "google_compute_subnetwork" "main" {
    name          = "diarlies-subnet"
    ip_cidr_range = "10.0.0.0/24"
    region        = var.region
    network       = google_compute_network.main.id
  }

  # VPC connector for Cloud Run to Cloud SQL
  resource "google_vpc_access_connector" "connector" {
    name          = "diarlies-vpc-connector"
    region        = var.region
    network       = google_compute_network.main.name
    ip_cidr_range = "10.8.0.0/28"
  }
  ```
- [ ] Create `apps/terraform/outputs.tf`:
  ```hcl
  output "project_id" {
    value = var.project_id
  }

  output "region" {
    value = var.region
  }

  output "db_connection_name" {
    value = google_sql_database_instance.diarlies.connection_name
  }

  output "db_name" {
    value = google_sql_database.diarlies.name
  }

  output "user_uploads_bucket" {
    value = google_storage_bucket.user_uploads.name
  }

  output "generated_images_bucket" {
    value = google_storage_bucket.generated_images.name
  }

  output "vpc_connector" {
    value = google_vpc_access_connector.connector.id
  }
  ```
- [ ] Update `apps/terraform/main.tf` with state backend configuration

### 3. Refactor Phase
- [ ] Run `terraform fmt` on all files
- [ ] Add variable validation rules
- [ ] Document all outputs in comments

## Completion Criteria
- [ ] All Terraform files formatted and validated
- [ ] VPC network and connector created
- [ ] All outputs defined
- [ ] Operation verified: `terraform plan` succeeds without errors (L3)
- [ ] Operation verified: `terraform apply` (dry-run) shows all resources

## Deliverables for Dependent Tasks
- **Complete Infrastructure**: All GCP resources ready for deployment
- **Terraform Outputs**: Available via `terraform output` command
- **VPC Connector**: For Cloud Run service configuration

## Notes
- Use Terraform remote state in GCS for production
- Impact scope: Foundation for all application deployment
- Constraints: All resources in same region for latency
- This completes Phase 1 (Infrastructure Foundation)
