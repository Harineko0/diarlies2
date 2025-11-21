# Diarlies Monorepo

Multi-app workspace for Diarlies, an AI-powered diary companion. The repo is organized under `apps/` with separate codebases for the web frontend, Go backend, Terraform infra, and Firebase assets.

## Layout
- `apps/web`: Next.js (App Router, TypeScript) client.
- `apps/backend`: Go HTTP API service.
- `apps/agent`: Google ADK Python agent (uv-managed).
- `apps/terraform`: Terraform configuration targeting Google Cloud.
- `apps/firebase`: Firebase project scaffolding and config.

## Getting Started
Clone the repo, then bootstrap each app as needed.

### Web (Next.js)
```bash
cd apps/web
pnpm install
pnpm dev
```

### Backend (Go)
```bash
cd apps/backend
go run ./cmd/api
```

### Agent (Google ADK, Python 3.11 via uv)
```bash
cd apps/agent
uv sync --all-groups
uv run adk run agents/hello          # CLI
uv run adk web agents/hello --port 8080  # Dev UI
```

### Terraform (Google Cloud)
```bash
cd apps/terraform
terraform init
terraform plan
```

### Firebase
```bash
cd apps/firebase
firebase use --add  # select or create your project
```

## Development Notes
- Keep shared contracts (e.g., API schemas, types) in a future `packages/` directory if needed.
- Favor `.env` files that are git-ignored; never commit secrets.
- Each app can evolve independently but should align on API shapes between web and backend.
- Agent CI: see `.github/workflows/agent.yml` (uv sync → ruff → black --check → pytest → uv build).
