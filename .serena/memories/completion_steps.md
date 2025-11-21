# Completion Steps

1) Run relevant formatters/linters:
- Web: `pnpm lint`, `pnpm format`, `pnpm test` (or focused `pnpm test -- --runInBand` if needed).
- Backend: `go fmt ./...`, `go test ./...` when Go code touched.
- Terraform: `terraform fmt`, `terraform plan` (review output, avoid committing state).
- Firebase: validate rules/indexes before deploy; do not check in secrets.

2) Verify app runs if affected:
- Web: `pnpm dev` and smoke critical pages.
- Backend: `go run ./cmd/api` and hit `/healthz` (PORT env optional).

3) Check git status/diff; ensure no unintended files (e.g., build artifacts) are staged.

4) For PRs: concise description, linked issues, screenshots for UI changes, mention migrations/env vars/infra changes. Note any test coverage gaps.

5) Keep secrets out of commits; prefer `.env` files (git-ignored) or platform secret managers.