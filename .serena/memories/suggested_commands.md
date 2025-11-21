# Suggested Commands

## Setup & General
- `pnpm install` (within apps/web) — install web dependencies.
- `pnpm dev` (apps/web) — run Next.js dev server.
- `pnpm build` / `pnpm start` (apps/web) — production build and serve.
- `pnpm lint` / `pnpm format` / `pnpm format:check` (apps/web) — Biome lint and format.
- `pnpm test` / `pnpm test:watch` (apps/web) — Vitest suite.
- `go run ./cmd/api` (apps/backend) — start Go API locally; PORT env optional (default 8080).
- `go test ./...` (apps/backend) — run Go tests (use gofmt before commits if you edit Go).
- `terraform init`, `terraform plan` (apps/terraform) — bootstrap and review infra changes.
- `firebase use --add` (apps/firebase) — select project; `firebase deploy` as needed.

## Repo Navigation
- Source lives under `apps/` (web, backend, terraform, firebase). Use `ls apps/` to list modules.
- Git: `git status`, `git diff`, `git add -p`, `git commit` as usual.

## System Notes
- Darwin (macOS) shell; standard tools available (ls, cd, rg/grep, find). Use `pnpm` (not npm/yarn) for web.