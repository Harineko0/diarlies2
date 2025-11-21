# Code Style and Conventions

## Web (Next.js / TypeScript)
- Uses Next.js App Router with TypeScript; keep components and routes under `apps/web/app`.
- Biome enforces lint + format; line width set to 100. Run `pnpm lint` and `pnpm format` before commits.
- Prefer functional React components, hooks, and TypeScript types/Interfaces; avoid implicit any.
- Keep imports sorted/grouped per Biome; avoid unused vars/imports (linter will flag).
- Naming: file and route segments kebab-case; components PascalCase; hooks camelCase starting with `use`.

## Backend (Go)
- Standard Go 1.22 module `diarlies/backend`; uses chi router and middleware.
- Use `gofmt` (or `go fmt ./...`) on changes; idiomatic naming (camelCase, exported with caps when needed).
- Keep handlers lightweight; add middleware via chi router.

## Terraform/Firebase
- Keep Terraform files under `apps/terraform` (main.tf, variables.tf, outputs.tf). Use clear variable names and modules when added.
- Firebase config in `apps/firebase` (rules/indexes/json). Do not commit secrets; prefer `.env` or local config.

## General
- Repository is UTF-8, spaces for indentation (TS usually 2 spaces; Go tabs via gofmt).
- Align web-backend contracts; document API changes in both clients.
- No secrets in git; use git-ignored env files and cloud secret stores.