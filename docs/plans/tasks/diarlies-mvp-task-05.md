# Task 05: Database Schema and Migrations

Metadata:
- Phase: 2 (Backend Foundation)
- Dependencies: Task 02 → Cloud SQL instance
- Provides:
  - Complete database schema
  - Migration files
  - Schema documentation
- Size: Medium (3-4 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Implement the complete PostgreSQL database schema as defined in designdoc_data.md, including users, diaries, and user_style_data tables with appropriate indexes and constraints.

## Target Files
- [ ] `apps/backend/migrations/001_initial_schema.sql`
- [ ] `apps/backend/migrations/migrate.go` (migration runner)
- [ ] `apps/backend/internal/db/schema.go` (Go types)
- [ ] `apps/backend/internal/db/schema_test.go`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_data.md complete schema
- [ ] Write test for migration runner execution
- [ ] Write test for schema validation (all tables exist)
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create `migrations/001_initial_schema.sql`:
  ```sql
  -- Users table
  CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    language_code VARCHAR(10) NOT NULL,
    writing_tone VARCHAR(50) NOT NULL,
    art_style VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
  );

  -- Diaries table
  CREATE TABLE diaries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    final_text TEXT NOT NULL,
    image_url TEXT NOT NULL,
    latitude NUMERIC,
    longitude NUMERIC,
    place_name VARCHAR(255),
    timezone VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
  );

  -- Indexes for diaries
  CREATE INDEX idx_diaries_user_id ON diaries(user_id);
  CREATE INDEX idx_diaries_user_created ON diaries(user_id, created_at DESC);

  -- User style data table for learning
  CREATE TABLE user_style_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL,
    style_fragment TEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, language_code, timestamp)
  );

  -- Index for style data retrieval
  CREATE INDEX idx_style_user_lang ON user_style_data(user_id, language_code);

  -- Trigger for updated_at
  CREATE OR REPLACE FUNCTION update_updated_at_column()
  RETURNS TRIGGER AS $$
  BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
  END;
  $$ language 'plpgsql';

  CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

  CREATE TRIGGER update_diaries_updated_at BEFORE UPDATE ON diaries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

  CREATE TRIGGER update_style_data_updated_at BEFORE UPDATE ON user_style_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  ```
- [ ] Create migration runner in `migrations/migrate.go`
- [ ] Create Go struct types in `internal/db/schema.go`:
  ```go
  type User struct {
    ID           string    `db:"id"`
    LanguageCode string    `db:"language_code"`
    WritingTone  string    `db:"writing_tone"`
    ArtStyle     string    `db:"art_style"`
    CreatedAt    time.Time `db:"created_at"`
    UpdatedAt    time.Time `db:"updated_at"`
  }

  type Diary struct {
    ID        string     `db:"id"`
    UserID    string     `db:"user_id"`
    FinalText string     `db:"final_text"`
    ImageURL  string     `db:"image_url"`
    Latitude  *float64   `db:"latitude"`
    Longitude *float64   `db:"longitude"`
    PlaceName *string    `db:"place_name"`
    Timezone  *string    `db:"timezone"`
    CreatedAt time.Time  `db:"created_at"`
    UpdatedAt time.Time  `db:"updated_at"`
  }

  type UserStyleData struct {
    ID            string    `db:"id"`
    UserID        string    `db:"user_id"`
    LanguageCode  string    `db:"language_code"`
    StyleFragment string    `db:"style_fragment"`
    Timestamp     time.Time `db:"timestamp"`
    CreatedAt     time.Time `db:"created_at"`
    UpdatedAt     time.Time `db:"updated_at"`
  }
  ```
- [ ] Implement migration runner
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Add comments explaining each table's purpose
- [ ] Verify all indexes are appropriate
- [ ] Add schema documentation in code comments

## Completion Criteria
- [ ] Migration file creates all tables successfully
- [ ] All indexes created
- [ ] Triggers for updated_at working
- [ ] Go types match SQL schema
- [ ] Tests pass for migration execution (L2)
- [ ] Operation verified: Migration runs successfully against Cloud SQL

## Deliverables for Dependent Tasks
- **Schema File**: `migrations/001_initial_schema.sql`
- **Go Types**: Available in `internal/db/schema.go`
- **Migration Runner**: For future schema changes

## Notes
- This is the single source of truth for database schema
- All future schema changes must be new migration files
- Impact scope: All backend data operations
- Constraints: PostgreSQL 15+ features used (gen_random_uuid)
