# Task 06: Go API Structure and Core Middleware

Metadata:
- Phase: 2 (Backend Foundation)
- Dependencies: Task 05 → Database schema
- Provides:
  - API router structure
  - Error handling middleware
  - Logging middleware
  - Database connection pool
- Size: Medium (4-5 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Establish Go backend API structure with chi router, core middleware (logging, error handling, CORS), and database connection management.

## Target Files
- [ ] `apps/backend/internal/api/router.go`
- [ ] `apps/backend/internal/api/middleware/error_handler.go`
- [ ] `apps/backend/internal/api/middleware/logger.go`
- [ ] `apps/backend/internal/db/connection.go`
- [ ] `apps/backend/internal/api/router_test.go`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Write test for router initialization
- [ ] Write test for error response format
- [ ] Write test for database connection pool
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create router with chi:
  ```go
  package api

  import (
    "github.com/go-chi/chi/v5"
    "github.com/go-chi/chi/v5/middleware"
  )

  func NewRouter() *chi.Mux {
    r := chi.NewRouter()

    // Core middleware
    r.Use(middleware.RequestID)
    r.Use(middleware.RealIP)
    r.Use(middleware.Logger)
    r.Use(middleware.Recoverer)
    r.Use(middleware.Timeout(60 * time.Second))

    return r
  }
  ```
- [ ] Create error handler:
  ```go
  package middleware

  type ErrorResponse struct {
    Error   string `json:"error"`
    Code    int    `json:"code"`
    Message string `json:"message"`
  }

  func ErrorHandler(err error, w http.ResponseWriter) {
    // Standard error response format
  }
  ```
- [ ] Create database connection pool
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Extract common response helpers
- [ ] Add structured logging
- [ ] Document middleware order

## Completion Criteria
- [ ] Router initializes successfully
- [ ] Middleware chain executes correctly
- [ ] Error responses follow consistent format
- [ ] Database connection pool functional
- [ ] All tests pass (L2)

## Deliverables for Dependent Tasks
- **Router**: Available for endpoint registration
- **Error Format**: Standard JSON error response
- **DB Pool**: Available for all database operations

## Notes
- Standard error format used across all endpoints
- Impact scope: All API endpoints
- Constraints: Use chi router as specified
