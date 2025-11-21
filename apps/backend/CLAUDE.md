# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Philosophy

**Simplicity over Magic:** Avoid heavy frameworks or ORMs that hide complexity. Prefer explicit code and standard library conventions.

**Standard Compatibility:** Stick to `net/http` compatible interfaces (`http.Handler`) to ensure modularity and long-term maintainability.

**Dependency Inversion:** Interfaces are defined by the **consumer** (Application Layer), not the implementer (Infrastructure Layer).

## Tech Stack

- **Router: `chi` (github.com/go-chi/chi/v5)**
  - Lightweight, fully compatible with standard `http.Handler`
  - Superior middleware/grouping capabilities compared to Go 1.22's `ServeMux`

- **Logging: `log/slog`** (Standard Library)
  - High-performance, structured (JSON) logging without external dependencies
  - Context-aware logging with request IDs

- **Database: `sqlx`**
  - Thin wrapper over `database/sql`
  - Removes boilerplate of scanning rows into structs while keeping raw SQL control
  - Avoid ORMs like GORM

## Architecture (DDD & Clean Architecture)

The project follows concentric layers to isolate business logic from technical details:

**Domain Layer (`internal/domain`)**
- Contains **Aggregates** and **Value Objects**
- Pure Go code with **no external dependencies**
- Enforces business invariants (rules)

**Application Layer (`internal/application`)**
- Contains **Use Cases** (Services)
- **Defines Interfaces** (e.g., `UserRepository`) that it needs to work
- Interfaces are owned by consumers, not implementers

**Infrastructure Layer (`internal/infrastructure`)**
- **Implements Interfaces** defined in the Application layer (e.g., `PostgresUserRepository`)
- Handles DB connections and external APIs

**Interface Adapter Layer (`internal/delivery`)**
- HTTP Handlers that convert requests/responses
- Depends only on the Application Layer

## Key Patterns

**Centralized Error Handling**
- Handlers return `error` instead of writing responses directly
- A top-level middleware catches errors, unwraps them using `errors.As`, and maps them to proper HTTP status codes and JSON responses

**Context-Aware Logging**
- A Request ID is generated at the entry point, passed via `context.Context`
- Automatically attached to all `slog` entries via a custom handler

## Common Commands

All commands are run from the repository root using Make:

### Development
```bash
make dev-backend              # Start Go API server (localhost:8080)
go run ./cmd/api              # Or run directly from apps/backend
```

### Testing
```bash
make test-backend             # Run all tests
make test-backend-verbose     # Run tests with -v flag

# From apps/backend directory:
go test ./...                 # Run all tests
go test -v ./...              # Verbose output
go test -run TestName         # Run specific test
go test ./internal/domain/... # Test specific package
```

### Code Quality
```bash
make lint-backend             # Check gofmt + go vet
make format-backend           # Format with gofmt

# From apps/backend directory:
gofmt -l .                    # List files needing formatting
gofmt -w .                    # Format all files
go vet ./...                  # Run go vet
```

### Build
```bash
make build-backend            # Build binary to bin/api (at repo root)

# From apps/backend directory:
go build -o ../../bin/api ./cmd/api
```

### Dependencies
```bash
go mod download               # Download dependencies
go get package@version        # Add/update dependency
go mod tidy                   # Clean up go.mod/go.sum
```

## Current Structure

**Entry Point:** `cmd/api/main.go`
- Simple chi-based HTTP server
- Middleware stack: RequestID, RealIP, Logger, Recoverer, Timeout(60s)
- Currently has `/healthz` endpoint
- Uses `PORT` environment variable (defaults to 8080)

**Future Structure (as you implement DDD layers):**
```
apps/backend/
├── cmd/api/main.go              # Entry point
├── internal/
│   ├── domain/                  # Business entities, value objects
│   ├── application/             # Use cases, interface definitions
│   ├── infrastructure/          # Repository implementations, DB
│   └── delivery/                # HTTP handlers
└── go.mod
```

## Code Conventions

- Use `gofmt` for formatting (tabs for indentation)
- Idiomatic Go naming: camelCase, exported with caps when needed
- Keep handlers lightweight; delegate to application layer
- Return errors from handlers; let middleware handle HTTP responses
- Pass `context.Context` through call chains for logging and cancellation
- Define interfaces where they're used (Application Layer), not where they're implemented

## Environment Variables

- `PORT`: HTTP server port (default: 8080)
- Keep configuration in environment variables or config files
- Never commit secrets; use cloud secret management in production
