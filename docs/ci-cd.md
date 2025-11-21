# CI/CD Guide for Diarlies

This repo uses GitHub Actions for checks and Google managed services for deployment (e.g., Cloud Build, App Hosting). Below is how to hook the apps into managed CI/CD once infrastructure is ready.

## Web (Next.js) on Google Cloud
1. **Build artifact with Cloud Build**  
   - Create a `cloudbuild.yaml` that runs `pnpm install` and `pnpm build` in `apps/web`.  
   - Set build steps to output the `.next` standalone artifacts or a Docker image.
2. **Deploy to App Hosting or Cloud Run**  
   - For Google App Hosting (preview), point the repo to the `apps/web` path and provide build commands above.  
   - For Cloud Run, containerize with a lightweight runtime (e.g., `gcr.io/distroless/nodejs20`).  
3. **Secrets & config**  
   - Store env vars in Secret Manager.  
   - Mount secrets via Cloud Run or App Hosting runtime configuration.

## Backend (Go) on Cloud Run
1. **Build**: Cloud Build step `gcr.io/cloud-builders/go` with `GO111MODULE=on go build ./cmd/api`.  
2. **Containerize**: Multi-stage Dockerfile suggested: `golang:1.22` builder → `gcr.io/distroless/base-debian12` runtime.  
3. **Deploy**: Use Cloud Run deploy step with proper region and service name.  
4. **Infra**: Point traffic through HTTPS load balancer if needed; wire in VPC connectors when required.

## Terraform
1. **State**: Create a Google Cloud Storage bucket for remote state; enable versioning and set uniform bucket-level access.  
2. **Service account**: Grant `roles/storage.objectAdmin` for state, plus least-privilege for managed resources.  
3. **Cloud Build pipeline**: Steps  
   - `terraform fmt -check`  
   - `terraform init -backend-config="bucket=YOUR_STATE_BUCKET"`  
   - `terraform validate`  
   - `terraform plan -out=tfplan` (optionally gated on PR approvals)  
   - `terraform apply tfplan` on main/prod promotions.

## Firebase Hosting
1. **Service account token**: Create a Firebase deploy SA; grant `roles/firebasehosting.admin`. Store its token or key in Secret Manager.  
2. **Cloud Build trigger**: Run `firebase deploy --only hosting` with `--project` set. Use `--non-interactive` and `--token` from secrets.  
3. **Preview channels**: Optionally create preview deploys on PR branches via `firebase hosting:channel:deploy`.

## General Recommendations
- Use separate projects/environments (dev/stage/prod) and map branches to triggers.  
- Enforce branch protections requiring GitHub Actions checks to pass before merge.  
- Keep `FIREBASE_TOKEN`, `GOOGLE_APPLICATION_CREDENTIALS`, and other secrets in GitHub Actions secrets (or OIDC to workload identity federation) instead of committing keys.  
- Once Cloud Build/App Hosting is wired, you can keep GitHub Actions as fast feedback while Google handles deployment.
