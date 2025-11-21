# Project Overview

Diarlies is an AI-powered diary companion monorepo. Everything lives under `apps/`:
- `apps/web`: Next.js 14 (App Router) client in TypeScript. Biome for lint/format; Vitest + Testing Library for tests.
- `apps/backend`: Go 1.22 HTTP API using chi router; simple `/healthz` now.
- `apps/terraform`: Terraform config targeting Google Cloud.
- `apps/firebase`: Firebase project scaffolding (rules, indexes, config).

Uses pnpm (packageManager set in apps/web). Keep shared contracts aligned between web and backend; future shared packages may live under `packages/` if added. Env files are git-ignored; never commit secrets.