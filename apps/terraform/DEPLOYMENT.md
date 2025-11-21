# Terraform Deployment Guide

This guide covers deploying infrastructure using the GitHub Actions workflow with workload identity authentication.

## Prerequisites

1. **GCP Project** with billing enabled
2. **GitHub Repository** with Actions enabled
3. **Local Development Environment**:
   - Terraform >= 1.5.0
   - `gcloud` CLI authenticated
   - Sufficient GCP permissions (Owner or Editor role)

## Initial Setup

### 1. Bootstrap Terraform State Storage

First, create the GCS bucket for storing Terraform state:

```bash
cd apps/terraform/bootstrap
export TF_VAR_project_id="your-gcp-project-id"
terraform init
terraform apply
```

**Save the bucket name** from the output - you'll need it in step 3.

### 2. Deploy Workload Identity Infrastructure

Deploy the workload identity pool, provider, and service account:

```bash
cd ../  # Back to apps/terraform
terraform init -backend=false
terraform apply \
  -var="project_id=your-gcp-project-id" \
  -var="github_org=your-github-username-or-org" \
  -var="github_repo=your-repo-name"
```

**Save these outputs**:
- `workload_identity_provider` - Full resource name of the provider
- `github_actions_service_account` - Email of the service account

### 3. Configure GitHub Repository

Add the following **Variables** (not secrets) in your GitHub repository:
- Go to Settings → Secrets and variables → Actions → Variables → New repository variable

| Variable Name | Value | Source |
|--------------|-------|--------|
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | `projects/.../locations/.../workloadIdentityPools/.../providers/...` | Terraform output |
| `GCP_SERVICE_ACCOUNT` | `diarlies-github-sa@....iam.gserviceaccount.com` | Terraform output |
| `GCP_PROJECT_ID` | `your-gcp-project-id` | Your GCP project |
| `TF_STATE_BUCKET` | `your-project-terraform-state` | Bootstrap output |
| `GITHUB_ORG` | `your-github-username-or-org` | Your GitHub org/user |
| `GITHUB_REPO` | `your-repo-name` | Your repository name |

### 4. Enable Required GCP APIs

```bash
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  cloudresourcemanager.googleapis.com \
  storage.googleapis.com \
  firebase.googleapis.com \
  firebasehosting.googleapis.com \
  --project=your-gcp-project-id
```

### 5. Migrate to Remote State

Now that the state bucket exists, migrate your local state to GCS:

```bash
cd apps/terraform
terraform init \
  -backend-config="bucket=your-project-terraform-state" \
  -backend-config="prefix=terraform/state" \
  -migrate-state
```

Answer "yes" when prompted to migrate state.

## Using the Deployment Workflow

### Automatic Deployment

When you push changes to the `main` branch that affect `apps/terraform/**`, the workflow will:
1. Authenticate using workload identity
2. Run `terraform plan`
3. Automatically apply the changes

### Manual Deployment

You can also trigger deployments manually:

1. Go to Actions → Deploy Terraform
2. Click "Run workflow"
3. Choose:
   - **plan**: Preview changes without applying
   - **apply**: Preview and apply changes

### Pull Request Validation

On pull requests, the workflow will:
1. Run format check, validation, and plan
2. Comment the plan output on the PR
3. **Not** apply changes (read-only)

## Local Development

### Running Terraform Locally

```bash
cd apps/terraform

# Initialize with remote state
terraform init \
  -backend-config="bucket=your-project-terraform-state" \
  -backend-config="prefix=terraform/state"

# Create a tfvars file
cat > terraform.tfvars <<EOF
project_id  = "your-gcp-project-id"
github_org  = "your-github-org"
github_repo = "your-repo-name"
EOF

# Plan and apply
terraform plan
terraform apply
```

### Without Remote State (for testing)

```bash
terraform init -backend=false
terraform plan
```

## Workflow Behavior

| Event | Branch | Action |
|-------|--------|--------|
| Push | `main` | Plan + Apply |
| Pull Request | Any | Plan only (comment on PR) |
| Manual | Any | Plan or Apply based on input |

## Security Notes

- **No secrets in GitHub**: Uses workload identity federation
- **Temporary credentials**: Tokens expire automatically
- **Scoped access**: Service account has only necessary permissions
- **Repository-scoped**: Only your repository can use the workload identity
- **State encryption**: GCS bucket uses encryption at rest

## Troubleshooting

### "Error: Failed to get existing workspaces"

Your service account doesn't have access to the state bucket. Grant it Storage Admin:

```bash
gcloud storage buckets add-iam-policy-binding gs://your-bucket \
  --member="serviceAccount:diarlies-github-sa@PROJECT.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

### "Error: Workload identity pool does not exist"

The workload identity infrastructure hasn't been deployed yet. Follow step 2 in Initial Setup.

### "Error: google: could not find default credentials"

For local development, authenticate with:

```bash
gcloud auth application-default login
```

## CI Validation

The existing `terraform.yml` workflow validates:
- Terraform formatting
- Configuration validity
- No actual deployment

The new `deploy-terraform.yml` workflow:
- Includes all CI checks
- Deploys infrastructure
- Uses workload identity authentication

## Adding New Resources

1. Add resources to `.tf` files in `apps/terraform/`
2. Update IAM roles in `workload_identity.tf` if the service account needs new permissions
3. Run `terraform fmt` to format
4. Commit and push to a branch
5. Open PR to see the plan
6. Merge to `main` to deploy

## Required GitHub Actions Permissions

The workflow requires these permissions in the job:
- `contents: read` - Read repository code
- `id-token: write` - Generate OIDC token for workload identity
- `pull-requests: write` - Comment plan on PRs
