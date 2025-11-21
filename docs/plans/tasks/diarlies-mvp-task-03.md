# Task 03: Cloud Storage Buckets and IAM Configuration

Metadata:
- Phase: 1 (Infrastructure Foundation)
- Dependencies: Task 01 → Project ID, Service Accounts
- Provides:
  - User uploads bucket name
  - Generated images bucket name
  - Signed URL generation helper
- Size: Small (2 files)
- Verification: L3 (Build/Deploy Success)

## Implementation Content
Create Cloud Storage buckets for user-uploaded images and AI-generated images, configure IAM policies, and implement signed URL generation utility.

## Target Files
- [ ] `apps/terraform/storage.tf`
- [ ] `apps/backend/internal/storage/signed_urls.go`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_data.md storage requirements
- [ ] Document bucket structure and access patterns
- [ ] Note: Private buckets, signed URLs, 15-minute expiry

### 2. Green Phase
- [ ] Create `apps/terraform/storage.tf`:
  ```hcl
  resource "google_storage_bucket" "user_uploads" {
    name          = "${var.project_id}-user-uploads"
    location      = var.region
    force_destroy = false

    uniform_bucket_level_access = true

    lifecycle_rule {
      action {
        type = "Delete"
      }
      condition {
        age = 90  # Clean up old uploads
      }
    }
  }

  resource "google_storage_bucket" "generated_images" {
    name          = "${var.project_id}-generated-images"
    location      = var.region
    force_destroy = false

    uniform_bucket_level_access = true
  }

  # IAM bindings for service accounts
  resource "google_storage_bucket_iam_member" "backend_uploads" {
    bucket = google_storage_bucket.user_uploads.name
    role   = "roles/storage.objectAdmin"
    member = "serviceAccount:${google_service_account.backend.email}"
  }
  ```
- [ ] Create signed URL helper in Go:
  ```go
  package storage

  import (
    "cloud.google.com/go/storage"
    "time"
  )

  func GenerateSignedURL(bucket, object string) (string, error) {
    // Generate 15-minute signed URL
    opts := &storage.SignedURLOptions{
      Scheme:  storage.SigningSchemeV4,
      Method:  "GET",
      Expires: time.Now().Add(15 * time.Minute),
    }
    return storage.SignedURL(bucket, object, opts)
  }
  ```

### 3. Refactor Phase
- [ ] Add bucket name outputs in Terraform
- [ ] Add error handling to signed URL generation
- [ ] Document bucket structure in comments

## Completion Criteria
- [ ] Both storage buckets created
- [ ] IAM policies configured
- [ ] Signed URL helper function implemented
- [ ] Terraform outputs include bucket names
- [ ] Operation verified: `terraform plan` shows buckets (L3)

## Deliverables for Dependent Tasks
- **User Uploads Bucket**: `${PROJECT_ID}-user-uploads`
- **Generated Images Bucket**: `${PROJECT_ID}-generated-images`
- **Signed URL Helper**: `apps/backend/internal/storage/signed_urls.go`

## Notes
- All buckets are private by default
- Signed URLs expire after 15 minutes
- Impact scope: Image upload and display features
- Constraints: Use uniform bucket-level access for security
