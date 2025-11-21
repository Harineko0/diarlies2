# Overall Design Document: AI-Powered Picture Diary MVP Implementation

Generation Date: 2025-11-21
Target Plan Document: PRD and Design Documents (docs/prd.md, docs/designdoc*.md)

## Project Overview

### Purpose and Goals
Implement a complete AI-Powered Picture Diary web application that allows users to effortlessly record daily experiences through an interactive dialogue system. The AI transforms minimal user input into personalized, illustrated diary entries while learning and adapting to the user's writing style over time.

### Background and Context
This is a greenfield implementation requiring:
- Full infrastructure provisioning on Google Cloud Platform
- Backend API development in Go
- Frontend web application in Next.js 14
- AI Agent workflow orchestration using ADK/Vertex AI
- Integration with Gemini 2.5 Flash (text) and Gemini 3 Pro Image Preview (images)
- Multi-language support with style learning mechanism
- Brutalism design aesthetic

## Task Division Design

### Division Policy
**Hybrid Approach with Foundation-First Strategy**:
- **Phase 1 (Foundation)**: Infrastructure and database setup (Horizontal - L3 verification)
- **Phase 2 (Core Backend)**: Authentication and basic API structure (Horizontal - L2 verification)
- **Phase 3 (Design System)**: UI components and design system (Horizontal - L2 verification)
- **Phase 4 (Feature Vertical)**: Feature-by-feature vertical slices (L1 verification)
- **Phase 5 (AI Integration)**: AI Agent and generation features (Vertical - L1 verification)
- **Phase 6 (Finalization)**: Calendar, learning mechanism, polish (Vertical - L1 verification)

**Rationale**:
- Foundation layers (infra, auth, design) benefit from horizontal implementation
- Features requiring AI integration benefit from vertical slices to ensure end-to-end functionality
- Each task maintains 1-5 file limit for reviewability

### Verifiability Level Distribution
- **L1 (User-facing features)**: Dialogue system, image generation, calendar view - 35% of tasks
- **L2 (Developer-facing)**: Components, API endpoints, database migrations - 50% of tasks
- **L3 (Infrastructure)**: Terraform, CI/CD, initial setup - 15% of tasks

### Inter-task Relationship Map
```
Phase 1: Infrastructure Foundation (L3 verification)
├── Task 01: GCP Project Setup → Deliverable: Project ID, Service Accounts
├── Task 02: Cloud SQL Setup → Deliverable: Database instance, connection strings
├── Task 03: Cloud Storage Setup → Deliverable: Buckets, IAM policies
└── Task 04: Terraform Configuration → Deliverable: Complete IaC

Phase 2: Backend Foundation (L2 verification)
├── Task 05: Database Schema → Deliverable: Migration files, schema.sql
├── Task 06: Go API Structure → Uses: Task 02 outputs
├── Task 07: better-auth Integration → Uses: Task 05, Task 06
└── Task 08: Health & Auth Endpoints → Uses: Task 07

Phase 3: Frontend Foundation (L2 verification)
├── Task 09: Design System Setup → Deliverable: Theme config, tokens
├── Task 10: Brutalism Components → Uses: Task 09
├── Task 11: i18n Configuration → Deliverable: Translation structure
└── Task 12: Layout & Navigation → Uses: Task 10, Task 11

Phase 4: User Authentication Flow (L1 verification)
├── Task 13: Auth Pages → Uses: Task 08, Task 10
└── Task 14: Protected Routes → Uses: Task 13

Phase 5: Core Diary Features (L1 verification)
├── Task 15: Input Page UI → Uses: Task 10, Task 12
├── Task 16: Google Maps Integration → Uses: Task 15
├── Task 17: Image Upload → Uses: Task 03, Task 15
└── Task 18: Style Selection → Uses: Task 15

Phase 6: AI Agent Foundation (L2 verification)
├── Task 19: ADK Setup → Uses: Task 01, Task 05
├── Task 20: Vertex AI Configuration → Uses: Task 19
└── Task 21: Gemini API Integration → Uses: Task 20

Phase 7: Dialogue & Text Generation (L1 verification)
├── Task 22: Backend Dialogue Endpoint → Uses: Task 21, Task 08
├── Task 23: Frontend Dialogue UI → Uses: Task 22, Task 18
└── Task 24: Text Generation Flow → Uses: Task 22, Task 23

Phase 8: Image Generation (L1 verification)
├── Task 25: Image Generation Endpoint → Uses: Task 21, Task 03
├── Task 26: Image Selection UI → Uses: Task 25, Task 17
└── Task 27: Retry & SLO Handling → Uses: Task 26

Phase 9: Diary Review & Editing (L1 verification)
├── Task 28: Review Page UI → Uses: Task 10, Task 24, Task 26
├── Task 29: Text Editing → Uses: Task 28
└── Task 30: Save Diary Entry → Uses: Task 29, Task 05

Phase 10: Style Learning (L1 verification)
├── Task 31: Style Data Storage → Uses: Task 05, Task 30
├── Task 32: Style Retrieval in AI Agent → Uses: Task 31, Task 21
└── Task 33: Style Application in Prompts → Uses: Task 32, Task 24

Phase 11: Calendar & Browsing (L1 verification)
├── Task 34: Calendar View UI → Uses: Task 10, Task 12
├── Task 35: Diary List API → Uses: Task 05, Task 08
├── Task 36: Diary Detail View → Uses: Task 35, Task 03
└── Task 37: Timezone Handling → Uses: Task 34, Task 35

Phase 12: Multi-Language Support (L1 verification)
├── Task 38: Language Switcher → Uses: Task 11, Task 12
├── Task 39: Language-Specific Prompts → Uses: Task 32, Task 38
└── Task 40: Language-Isolated Learning → Uses: Task 31, Task 38

Phase 13: Theme & Polish (L1 verification)
├── Task 41: Dark Mode → Uses: Task 09, Task 10
├── Task 42: Loading States → Uses: Task 10, Task 27
├── Task 43: Error Handling → Uses: Task 10, Task 42
└── Task 44: Responsive Design → Uses: All UI tasks

Phase 14: Testing & Quality (L2 verification)
├── Task 45: Backend Unit Tests → Uses: All backend tasks
├── Task 46: Frontend Component Tests → Uses: All frontend tasks
├── Task 47: Integration Tests → Uses: All API tasks
└── Task 48: E2E Tests → Uses: All feature tasks

Phase 15: Deployment & CI/CD (L3 verification)
├── Task 49: Cloud Run Deployment → Uses: Task 01, Task 06
├── Task 50: Frontend Hosting → Uses: Task 01, Task 12
├── Task 51: GitHub Actions → Deliverable: CI/CD workflows
└── Task 52: Production Configuration → Uses: Task 49, Task 50

Phase 16: Final Integration (L1 verification)
└── Task 53: End-to-End Verification → Uses: All tasks
```

### Interface Change Impact Analysis
| Component | Interface | Dependencies | Risk Level |
|-----------|-----------|--------------|------------|
| Database Schema | All tables defined in designdoc_data.md | Backend, AI Agent | High |
| better-auth | Auth endpoints, session management | All protected routes | High |
| AI Agent API | Dialogue, text gen, image gen endpoints | Frontend features | High |
| Gemini API | Text and image generation | AI Agent workflows | Medium |
| Cloud Storage | Signed URLs, image storage | Image upload/display | Medium |
| Google Maps | Location selection | Input page | Low |

### Common Processing Points
**Shared Across Tasks**:
1. **Authentication Middleware**: Used in all protected API endpoints (Task 07, implemented once)
2. **Error Response Format**: Standardized JSON error structure (Task 06, implemented once)
3. **Brutalism Style Tokens**: Design system variables (Task 09, implemented once)
4. **i18n Translation Hook**: Used in all UI components (Task 11, implemented once)
5. **Signed URL Generation**: Used for all image access (Task 03, implemented once)
6. **SLO Monitoring Wrapper**: Used for all AI calls (Task 21, implemented once)

## Implementation Considerations

### Principles to Maintain Throughout
1. **TDD Compliance**: All tasks follow Red-Green-Refactor cycle
2. **Atomic Commits**: Each task = 1 commit (1-5 files)
3. **Dependency Clarity**: Explicit deliverable handoff between tasks
4. **Verification Level**: Each task specifies L1/L2/L3 verification
5. **No Duplication**: Common processing identified and shared
6. **Language Isolation**: Multi-language features ensure data separation

### Risks and Countermeasures
- **Risk**: Gemini API rate limits or quota issues
  **Countermeasure**: Implement retry logic with exponential backoff in Task 21

- **Risk**: Database migration conflicts
  **Countermeasure**: Single migration file in Task 05, all schema changes through that file

- **Risk**: Authentication integration complexity
  **Countermeasure**: better-auth setup isolated in Task 07 with comprehensive tests

- **Risk**: AI Agent deployment complexity
  **Countermeasure**: ADK setup in separate task (19) before integration tasks

- **Risk**: Brutalism design consistency
  **Countermeasure**: Design system tokens in Task 09, referenced by all UI tasks

- **Risk**: Multi-language prompt engineering
  **Countermeasure**: Language-specific prompt templates in Task 39

### Impact Scope Management
**Allowed Change Scope**:
- New files in apps/web, apps/backend, apps/terraform
- New database migrations (forward-only)
- New AI Agent Python code
- New test files
- Documentation updates

**No-Change Areas**:
- Existing Makefile structure (only add targets)
- pnpm workspace configuration
- Existing .github workflows (until Task 51)
- Project root configuration files

### Implementation Order Optimization
**Critical Path**:
1. Infrastructure (Tasks 1-4) - Blocking all cloud-dependent work
2. Database Schema (Task 5) - Blocking all data operations
3. Auth Setup (Tasks 6-8) - Blocking all protected features
4. Design System (Tasks 9-12) - Blocking all UI features
5. AI Agent Setup (Tasks 19-21) - Blocking all generation features

**Parallel Workstreams Available**:
- After Task 8: Frontend work (Tasks 13-18) can proceed in parallel with AI setup (Tasks 19-21)
- After Task 21: Feature tasks (22-44) can proceed in any order within phase dependencies
- Testing tasks (45-48) can be developed alongside feature tasks

### SLO Requirements Integration
**Text Generation (3s SLO)**:
- Task 24: Implement monitoring and logging
- No retry UI needed (fails fast)
- Return partial progress if timeout

**Image Generation (10s SLO)**:
- Task 27: Implement "long-running" status response
- Frontend shows retry UI after 10s
- Backend deduplicates retry requests

## Success Criteria
- [ ] All 53 tasks completed and verified at appropriate level
- [ ] Full E2E flow working: Sign up → Create diary → View in calendar
- [ ] Text generation completes in < 3s (95th percentile)
- [ ] Image generation completes in < 10s (95th percentile) or shows retry UI
- [ ] Multi-language support verified for English and Japanese
- [ ] Style learning demonstrates improvement after 3 diary entries
- [ ] All tests passing (unit, integration, E2E)
- [ ] Brutalism design principles applied consistently
- [ ] Infrastructure fully provisioned via Terraform
- [ ] CI/CD pipeline functional

## Notes
- Total estimated tasks: 53 (manageable for MVP)
- Each phase ends with verification checkpoint
- Phases 1-3 are horizontal (foundation building)
- Phases 4-13 are vertical (feature delivery)
- Phases 14-16 are integration and quality
- All tasks designed for single-commit granularity
- Deliverables explicitly tracked for dependent tasks
