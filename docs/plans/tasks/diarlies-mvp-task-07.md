# Task 07: better-auth Integration and Session Management

Metadata:
- Phase: 2 (Backend Foundation)
- Dependencies: Tasks 05, 06 → Database, API structure
- Provides:
  - better-auth configuration
  - Authentication middleware
  - Session management
- Size: Medium (3-4 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Integrate better-auth for user authentication and session management with PostgreSQL session storage.

## Target Files
- [ ] `apps/backend/internal/auth/config.go`
- [ ] `apps/backend/internal/auth/middleware.go`
- [ ] `apps/backend/internal/auth/handlers.go`
- [ ] `apps/backend/internal/auth/auth_test.go`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review better-auth documentation
- [ ] Write test for auth middleware with valid token
- [ ] Write test for auth middleware with invalid token
- [ ] Write test for user context extraction
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Configure better-auth client:
  ```go
  package auth

  import "github.com/better-auth/better-auth-go"

  type Config struct {
    Secret   string
    DBConnString string
  }

  func NewAuthClient(cfg Config) (*betterauth.Client, error) {
    return betterauth.NewClient(betterauth.Config{
      Secret: cfg.Secret,
      Database: cfg.DBConnString,
      // Additional configuration
    })
  }
  ```
- [ ] Create authentication middleware:
  ```go
  func AuthMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      // Extract and validate token
      // Add user context to request
      next.ServeHTTP(w, r)
    })
  }
  ```
- [ ] Implement user context helpers
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Extract token validation logic
- [ ] Add comprehensive error messages
- [ ] Document authentication flow

## Completion Criteria
- [ ] better-auth integrated with PostgreSQL
- [ ] Auth middleware validates tokens correctly
- [ ] User context available in protected routes
- [ ] Tests pass for auth flows (L2)

## Deliverables for Dependent Tasks
- **Auth Middleware**: For protecting endpoints
- **User Context**: Helper to extract user from request
- **Auth Config**: Shared configuration

## Notes
- Store auth secret in Secret Manager for production
- Impact scope: All protected API endpoints
- Constraints: Must use PostgreSQL for session storage
