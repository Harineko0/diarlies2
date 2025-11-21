# Task 31: Style Data Storage on Save

Metadata:
- Phase: 10 (Style Learning)
- Dependencies: Tasks 05, 30 → Database schema, Save diary functionality
- Provides:
  - Style data extraction
  - Style storage logic
  - Learning data accumulation
- Size: Small (2 files)
- Verification: L1 (User-facing Feature)

## Implementation Content
Implement the style learning mechanism by extracting and storing user-edited text as style data when saving diary entries, enabling the AI to learn the user's writing preferences.

## Target Files
- [ ] `apps/backend/internal/learning/style_extractor.go`
- [ ] `apps/backend/internal/learning/style_extractor_test.go`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_ai_agent.md style learning requirements (R3.2, R3.3)
- [ ] Write test for style data extraction
- [ ] Write test for style data storage with language isolation
- [ ] Write test for duplicate prevention
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create style extractor:
  ```go
  package learning

  import (
    "context"
    "time"
    "database/sql"
  )

  type StyleExtractor struct {
    db *sql.DB
  }

  func NewStyleExtractor(db *sql.DB) *StyleExtractor {
    return &StyleExtractor{db: db}
  }

  // ExtractAndStore extracts style data from user's final text
  func (se *StyleExtractor) ExtractAndStore(
    ctx context.Context,
    userID string,
    languageCode string,
    finalText string,
  ) error {
    // Extract style fragment (could be full text or summary)
    styleFragment := finalText // For MVP, store full text

    // Store with language isolation (R4.4)
    query := `
      INSERT INTO user_style_data (user_id, language_code, style_fragment, timestamp)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (user_id, language_code, timestamp) DO NOTHING
    `

    _, err := se.db.ExecContext(
      ctx,
      query,
      userID,
      languageCode,
      styleFragment,
      time.Now(),
    )

    return err
  }

  // GetUserStyleData retrieves style data for AI prompting
  func (se *StyleExtractor) GetUserStyleData(
    ctx context.Context,
    userID string,
    languageCode string,
    limit int,
  ) ([]string, error) {
    query := `
      SELECT style_fragment
      FROM user_style_data
      WHERE user_id = $1 AND language_code = $2
      ORDER BY timestamp DESC
      LIMIT $3
    `

    rows, err := se.db.QueryContext(ctx, query, userID, languageCode, limit)
    if err != nil {
      return nil, err
    }
    defer rows.Close()

    var fragments []string
    for rows.Next() {
      var fragment string
      if err := rows.Scan(&fragment); err != nil {
        return nil, err
      }
      fragments = append(fragments, fragment)
    }

    return fragments, nil
  }
  ```
- [ ] Integrate with save diary endpoint:
  ```go
  // In diary save handler
  func (h *DiaryHandler) SaveDiary(w http.ResponseWriter, r *http.Request) {
    // ... existing save logic ...

    // Store style data for learning (R3.2)
    if err := h.styleExtractor.ExtractAndStore(
      ctx,
      userID,
      user.LanguageCode,
      diary.FinalText,
    ); err != nil {
      // Log error but don't fail save
      log.Printf("Failed to store style data: %v", err)
    }

    // ... rest of save logic ...
  }
  ```
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Add logging for style data storage
- [ ] Consider extracting key phrases instead of full text
- [ ] Document learning mechanism

## Completion Criteria
- [ ] Style data extracted from saved diaries
- [ ] Style data stored with language isolation
- [ ] Duplicate timestamps handled
- [ ] Style retrieval working
- [ ] Tests pass (L2)
- [ ] Operation verified: Saving diary stores style data in database (L1)

## Deliverables for Dependent Tasks
- **Style Extractor**: For AI agent to retrieve learning data
- **Style Storage**: Learning data accumulating per user per language

## Notes
- Language isolation critical per R4.4
- Each save adds to learning corpus
- Impact scope: AI text generation quality improvement
- Constraints: Must separate by language_code
