# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Diarlies is an AI-powered diary companion monorepo with multiple apps:
- **apps/web**: Next.js 14 (App Router) frontend with TypeScript, React Testing Library, and Vitest
- **apps/backend**: Go 1.22 HTTP API using chi router
- **apps/agent**: Google ADK Python agent (uv-managed)
- **apps/terraform**: Google Cloud infrastructure provisioning
- **apps/firebase**: Firebase project configuration (Firestore rules, hosting)

This is a pnpm workspace with apps managed independently under `apps/`.

## Build System

**Use the Makefile for all development tasks.** It provides a unified interface across all apps:
- Run `make help` to see all available commands organized by category
- All commands can be run from the repository root
- No need to `cd` into individual app directories (the Makefile handles that)
- Backend binary builds to `bin/api` at the root

## Architecture

### Web App (Next.js)
- Uses Next.js 14 App Router (not Pages Router)
- Biome for linting and formatting (not ESLint/Prettier as primary tools)
- Vitest + React Testing Library for tests
- Package manager: pnpm (not npm/yarn)
- Located in `apps/web`

### Backend (Go)
- Simple chi-based HTTP server in `apps/backend/cmd/api/main.go`
- Minimal structure: currently only has `/healthz` endpoint
- Uses environment variable `PORT` (defaults to 8080)
- Chi middleware: RequestID, RealIP, Logger, Recoverer, Timeout

### Agent (Google ADK, Python)
- ADK agent code lives under `apps/agent/agents/**` with `root_agent` defined in each agent module
- Managed with `uv`; dependencies in `pyproject.toml`, lock in `uv.lock`
- Dev commands (from `apps/agent`): `uv sync --all-groups`, `uv run adk run agents/hello`, `uv run adk web agents/hello --port 8080`
- Quality/build: `uv run ruff check .`, `uv run black --check .`, `uv run pytest`, `uv build`

### Infrastructure
- Terraform targets Google Cloud Platform (not AWS/Azure)
- Basic VPC networking setup in `apps/terraform/main.tf`
- Firebase for Firestore (auth-gated: `request.auth != null`)
- Designed for Cloud Run deployment (see docs/ci-cd.md)

### CI/CD Strategy
- GitHub Actions for PR checks (lint, test, build)
- Path-based triggers: changes to `apps/web/**`, `apps/backend/**`, `apps/agent/**`, etc.
- Production deployment via Google Cloud Build / App Hosting (see docs/ci-cd.md)
- State management: Terraform remote state in GCS bucket
- Agent workflow: `.github/workflows/agent.yml` (uv sync → ruff → black --check → pytest → uv build)

## Common Commands

All commands are run from the repository root using Make:

### Setup & Installation
```bash
make help                # Show all available commands
make install             # Install all dependencies (web + backend)
make install-web         # Install only web dependencies
make install-backend     # Install only backend dependencies
make install-terraform   # Initialize Terraform (without backend config)
```

### Development
```bash
make dev-web             # Start Next.js dev server (localhost:3000)
make dev-backend         # Start Go API server (localhost:8080)
make dev                 # Instructions for running both (requires 2 terminals)
make dev-agent           # Run agent CLI (uv run adk run agents/hello)
```

### Testing
```bash
make test                # Run all tests (web + backend)
make test-web            # Run web tests only
make test-web-watch      # Run web tests in watch mode
make test-backend        # Run backend tests
make test-backend-verbose # Run backend tests with -v flag
make test-agent          # Run agent tests (uv run pytest)
```

### Code Quality
```bash
make lint                # Lint all code (web + backend + terraform)
make lint-web            # Lint web with Biome
make lint-backend        # Check gofmt + go vet
make lint-terraform      # Check terraform fmt
make lint-agent          # Lint agent (uv run ruff check .)

make format              # Format all code (web + backend + terraform)
make format-web          # Format web with Biome
make format-backend      # Format backend with gofmt
make format-terraform    # Format terraform files
make format-agent        # Format-check agent (uv run black --check .)
```

### Build
```bash
make build               # Build all applications
make build-web           # Build Next.js production bundle
make build-backend       # Build Go binary to bin/api
make build-agent         # Build agent package (uv build)
```

### CI/CD
```bash
make ci                  # Run all CI checks locally (lint + test + build)
make ci-web              # Run web CI checks
make ci-backend          # Run backend CI checks
make ci-terraform        # Run terraform CI checks
```

### Terraform
```bash
make tf-validate         # Validate Terraform config (init without backend)
make tf-plan             # Run terraform plan (requires backend config)
make tf-apply            # Apply terraform changes (with confirmation prompt)
```

### Firebase
```bash
make firebase-deploy            # Deploy everything to Firebase
make firebase-deploy-hosting    # Deploy only hosting
make firebase-deploy-rules      # Deploy only Firestore rules
```

### Cleanup
```bash
make clean               # Clean all build artifacts
make clean-web           # Clean web (.next, node_modules)
make clean-backend       # Clean backend (bin/)
make clean-terraform     # Clean terraform (.terraform)
make clean-all           # Deep clean including pnpm-lock.yaml
```

### Utilities
```bash
make check-deps          # Check for outdated dependencies
make update-deps         # Update dependencies (use with caution)
```

## Running CI Checks Locally

To replicate GitHub Actions checks before pushing:

```bash
make ci                  # Runs lint, format check, tests, and build for all apps
make ci-agent            # Agent CI (uv sync + ruff + black --check + pytest + uv build)
```

Or run checks for individual apps:
```bash
make ci-web              # Web: lint + format:check + test + build
make ci-backend          # Backend: gofmt + go vet + go test
make ci-terraform        # Terraform: fmt check + validate
```

## Key Conventions

- Never commit secrets or `.env` files (use Secret Manager for production)
- API contracts between web and backend should align (future shared `packages/` for types)
- Each app is independently deployable but shares naming conventions
- Use `var.app_name` in Terraform for resource naming consistency
- Firestore rules require authentication for all read/write operations
- Backend uses PORT env var for flexible deployment (Cloud Run compatibility)
