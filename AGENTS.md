# Repository Guidelines

## Project Structure & Module Organization
- Monorepo lives under `apps/`: `apps/web` (Next.js + TypeScript), `apps/backend` (Go 1.22 + chi), `apps/terraform` (GCP infra), `apps/firebase` (rules/indexes/config). Keep module-specific assets and configs inside each folder.
- Web routes/components stay in `apps/web/app`; backend entrypoint is `apps/backend/cmd/api/main.go`. Add future shared types under a `packages/` folder when needed.

## Build, Test, and Development Commands
- Make entrypoint: `make help` lists tasks. Common: `make dev-web` / `make dev-backend`; `make test`, `make lint`, `make format`, `make build`, `make ci`.
- Web: `cd apps/web && pnpm dev` (local), `pnpm build && pnpm start` (prod), `pnpm lint`, `pnpm format` / `pnpm format:check`, `pnpm test` or `pnpm test:watch`.
- Backend: `cd apps/backend && go run ./cmd/api` (API `/healthz`, `PORT` overrides 8080), `go test ./...`; `make build-backend` writes `bin/api`.
- Infra: Terraform `cd apps/terraform && terraform init -backend=false` for local, `terraform plan` before apply (see `make tf-*` helpers). Firebase: `cd apps/firebase && firebase use --add`; deploy with `make firebase-deploy`.

## Coding Style & Naming Conventions
- TypeScript/React: Biome controls lint/format (line width 100). Components PascalCase, hooks camelCase starting with `use`, route segments/files kebab-case. Type everything; avoid implicit `any`. Keep imports tidy and unused-free (Biome enforces).
- Go: run `gofmt`/`go fmt ./...`; camelCase for locals, export with caps when needed. Keep handlers small and use chi middleware consistently.
- Infra: prefer clear variable names and module structure in Terraform; never commit state or secrets.

## Testing Guidelines
- Web: Vitest + Testing Library. Place specs as `*.test.ts|tsx` near sources. Cover critical rendering states, hooks, and data handling. Use `pnpm test -- --runInBand` or `make test-web` if flakiness appears.
- Backend: add `*_test.go` alongside code; hit handlers and env logic. Use `go test ./...` or `make test-backend` pre-push.

## Commit & Pull Request Guidelines
- Commits: concise, imperative subject lines (e.g., `Add health check handler`). Keep scoped; avoid bundling unrelated changes.
- PRs: describe intent and impact, link issues, note env/infra changes, and attach UI screenshots when applicable. Call out test coverage and any gaps.

## Security & Configuration Tips
- Secrets stay out of repo—use `.env` files (git-ignored) or platform stores. Sanitize logs. Review Terraform/Firebase changes carefully, and align API contracts between web and backend when modifying endpoints or types.
