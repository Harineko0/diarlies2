# Task 01: GCP Project Setup and Service Account Configuration

Metadata:
- Phase: 1 (Infrastructure Foundation)
- Dependencies: None
- Provides:
  - GCP Project ID
  - Service Account credentials
  - API enablement list
- Size: Small (2-3 files)
- Verification: L3 (Build/Deploy Success)

## Implementation Content
Set up the Google Cloud Platform project foundation with required APIs enabled and service accounts configured. This establishes the basic cloud environment for all subsequent infrastructure and application deployment.

## Target Files
- [ ] `apps/terraform/variables.tf` (define project variables)
- [ ] `apps/terraform/providers.tf` (configure GCP provider)
- [ ] `docs/infra/gcp-setup.md` (setup documentation)

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_infra.md requirements
- [ ] Document GCP project requirements in setup guide
- [ ] List required APIs: Compute Engine, Cloud SQL Admin, Cloud Storage, Vertex AI, Cloud Run
- [ ] Define service account roles needed

### 2. Green Phase
- [ ] Create GCP project via Console or gcloud CLI
- [ ] Enable required APIs:
  ```bash
  gcloud services enable compute.googleapis.com
  gcloud services enable sqladmin.googleapis.com
  gcloud services enable storage.googleapis.com
  gcloud services enable aiplatform.googleapis.com
  gcloud services enable run.googleapis.com
  ```
- [ ] Create service accounts:
  - `diarlies-backend-sa` (for Go API)
  - `diarlies-ai-agent-sa` (for Python ADK)
- [ ] Grant minimum required roles
- [ ] Create and download service account keys
- [ ] Update terraform/variables.tf with project_id variable
- [ ] Update terraform/providers.tf with GCP provider config

### 3. Refactor Phase
- [ ] Document setup steps in docs/infra/gcp-setup.md
- [ ] Add comments explaining service account roles
- [ ] Verify Terraform can authenticate

## Completion Criteria
- [ ] GCP project created and accessible
- [ ] All required APIs enabled
- [ ] Service accounts created with appropriate IAM roles
- [ ] Terraform provider configuration validates successfully
- [ ] Documentation complete with project ID and setup steps
- [ ] Operation verified: `terraform init` succeeds (L3)

## Deliverables for Dependent Tasks
- **Project ID**: To be used in all Terraform resources
- **Service Account Emails**: For IAM binding in subsequent tasks
- **Documentation**: Setup guide at `docs/infra/gcp-setup.md`

## Notes
- Store service account keys securely (not in git)
- Use Secret Manager for production keys
- Impact scope: Foundation for all GCP resources
- Constraints: Must use single GCP project for MVP
