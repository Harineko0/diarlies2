# Task 02: Cloud SQL PostgreSQL Setup

Metadata:
- Phase: 1 (Infrastructure Foundation)
- Dependencies: Task 01 → Project ID, Service Account
- Provides:
  - Cloud SQL instance connection string
  - Database name
  - Private IP address
- Size: Small (2 files)
- Verification: L3 (Build/Deploy Success)

## Implementation Content
Provision Cloud SQL PostgreSQL instance with private IP networking and configure connection settings for the backend API.

## Target Files
- [ ] `apps/terraform/cloudsql.tf`
- [ ] `docs/infra/database-setup.md`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_data.md schema requirements
- [ ] Review designdoc_infra.md database specifications
- [ ] Document required database configuration
- [ ] Note: PostgreSQL 15, private IP, automated backups

### 2. Green Phase
- [ ] Create `apps/terraform/cloudsql.tf`:
  ```hcl
  resource "google_sql_database_instance" "diarlies" {
    name             = "diarlies-db-instance"
    database_version = "POSTGRES_15"
    region           = var.region

    settings {
      tier = "db-f1-micro"  # Adjust for production
      ip_configuration {
        ipv4_enabled    = false
        private_network = google_compute_network.main.id
      }
      backup_configuration {
        enabled = true
        start_time = "03:00"
      }
    }
  }

  resource "google_sql_database" "diarlies" {
    name     = "diarlies"
    instance = google_sql_database_instance.diarlies.name
  }

  resource "google_sql_user" "diarlies" {
    name     = "diarlies_app"
    instance = google_sql_database_instance.diarlies.name
    password = random_password.db_password.result
  }
  ```
- [ ] Add database connection string output
- [ ] Create docs/infra/database-setup.md with connection details

### 3. Refactor Phase
- [ ] Add comments explaining configuration choices
- [ ] Document connection string format
- [ ] Add Terraform output for connection info

## Completion Criteria
- [ ] Cloud SQL instance created successfully
- [ ] Database and user created
- [ ] Private IP networking configured
- [ ] Connection string documented
- [ ] Operation verified: `terraform plan` shows resource creation (L3)

## Deliverables for Dependent Tasks
- **Instance Connection Name**: projects/PROJECT_ID/instances/INSTANCE_NAME
- **Database Name**: "diarlies"
- **Private IP**: For VPC connector configuration
- **Documentation**: Connection guide at `docs/infra/database-setup.md`

## Notes
- Use Secret Manager for database password in production
- Private IP requires VPC connector for Cloud Run
- Impact scope: Backend API database connectivity
- Constraints: Must use PostgreSQL 15+ for JSON support
