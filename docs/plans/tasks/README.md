# Diarlies MVP Task Decomposition

This directory contains the complete task breakdown for implementing the AI-Powered Picture Diary MVP. Each task is designed to be completed in a single commit with 1-5 files.

## Overview

- **Total Tasks**: 53 implementation tasks + 16 phase completion checkpoints
- **Approach**: Hybrid (Foundation-first horizontal, then vertical slices)
- **Verification Levels**: L1 (User-facing), L2 (Developer-facing), L3 (Infrastructure)

## Phase Structure

### Phase 1: Infrastructure Foundation (Tasks 01-04) - L3 Verification
- [x] Task 01: GCP Project Setup
- [x] Task 02: Cloud SQL Setup
- [x] Task 03: Cloud Storage Setup
- [x] Task 04: Complete Terraform Configuration
- [x] Phase 1 Completion Checkpoint

### Phase 2: Backend Foundation (Tasks 05-08) - L2 Verification
- [x] Task 05: Database Schema and Migrations
- [x] Task 06: Go API Structure and Middleware
- [x] Task 07: better-auth Integration
- [ ] Task 08: Health Check and Auth API Endpoints
- [ ] Phase 2 Completion Checkpoint

### Phase 3: Frontend Foundation (Tasks 09-12) - L2 Verification
- [x] Task 09: Design System Setup
- [ ] Task 10: Brutalism UI Components Library
- [ ] Task 11: i18n Configuration and Translation Setup
- [ ] Task 12: App Layout and Navigation
- [ ] Phase 3 Completion Checkpoint

### Phase 4: User Authentication Flow (Tasks 13-14) - L1 Verification
- [ ] Task 13: Authentication Pages (Sign In/Sign Up)
- [ ] Task 14: Protected Route Guards
- [ ] Phase 4 Completion Checkpoint

### Phase 5: Core Diary Input (Tasks 15-18) - L1 Verification
- [ ] Task 15: Diary Input Page UI Structure
- [ ] Task 16: Google Maps Location Selection
- [ ] Task 17: Image Upload Functionality
- [ ] Task 18: Style Selection UI (Writing Tone & Art Style)
- [ ] Phase 5 Completion Checkpoint

### Phase 6: AI Agent Foundation (Tasks 19-21) - L2 Verification
- [ ] Task 19: Python ADK Setup and Project Structure
- [ ] Task 20: Vertex AI Agent Builder Configuration
- [ ] Task 21: Gemini API Integration and SLO Monitoring
- [ ] Phase 6 Completion Checkpoint

### Phase 7: Dialogue & Text Generation (Tasks 22-24) - L1 Verification
- [ ] Task 22: Backend Dialogue API Endpoint
- [ ] Task 23: Frontend Interactive Dialogue UI
- [ ] Task 24: Text Generation Integration and Display
- [ ] Phase 7 Completion Checkpoint

### Phase 8: Image Generation (Tasks 25-27) - L1 Verification
- [ ] Task 25: Image Generation API Endpoint
- [ ] Task 26: Image Selection UI (Multiple Patterns)
- [ ] Task 27: Image SLO Handling and Retry UI
- [ ] Phase 8 Completion Checkpoint

### Phase 9: Diary Review & Editing (Tasks 28-30) - L1 Verification
- [ ] Task 28: Review Page UI Layout
- [ ] Task 29: Text Editing Functionality
- [ ] Task 30: Save Diary Entry with Image
- [ ] Phase 9 Completion Checkpoint

### Phase 10: Style Learning (Tasks 31-33) - L1 Verification
- [ ] Task 31: Style Data Storage on Save
- [ ] Task 32: Style Data Retrieval in AI Agent
- [ ] Task 33: Style Application in Text Generation
- [ ] Phase 10 Completion Checkpoint

### Phase 11: Calendar & Browsing (Tasks 34-37) - L1 Verification
- [ ] Task 34: Calendar View UI Component
- [ ] Task 35: Diary List API Endpoint
- [ ] Task 36: Diary Detail View Page
- [ ] Task 37: Timezone Handling and Date Display
- [ ] Phase 11 Completion Checkpoint

### Phase 12: Multi-Language Support (Tasks 38-40) - L1 Verification
- [ ] Task 38: Language Switcher UI
- [ ] Task 39: Language-Specific AI Prompts
- [ ] Task 40: Language-Isolated Style Learning
- [ ] Phase 12 Completion Checkpoint

### Phase 13: Theme & Polish (Tasks 41-44) - L1 Verification
- [ ] Task 41: Dark Mode Theme Toggle
- [ ] Task 42: Loading States and Animations
- [ ] Task 43: Error Handling and User Feedback
- [ ] Task 44: Responsive Design Implementation
- [ ] Phase 13 Completion Checkpoint

### Phase 14: Testing & Quality (Tasks 45-48) - L2 Verification
- [ ] Task 45: Backend Unit Tests Suite
- [ ] Task 46: Frontend Component Tests Suite
- [ ] Task 47: API Integration Tests
- [ ] Task 48: E2E User Flow Tests
- [ ] Phase 14 Completion Checkpoint

### Phase 15: Deployment & CI/CD (Tasks 49-52) - L3 Verification
- [ ] Task 49: Cloud Run Deployment Configuration
- [ ] Task 50: Frontend Firebase Hosting Setup
- [ ] Task 51: GitHub Actions CI/CD Workflows
- [ ] Task 52: Production Environment Configuration
- [ ] Phase 15 Completion Checkpoint

### Phase 16: Final Integration (Task 53) - L1 Verification
- [ ] Task 53: Complete E2E Flow Verification
- [ ] Phase 16 Completion Checkpoint

## Task File Naming Convention

`diarlies-mvp-task-{number}.md` - Individual tasks
`diarlies-mvp-phase{number}-completion.md` - Phase checkpoints

## Reading Order

1. Start with `_overview-diarlies-mvp.md` for overall strategy
2. Follow phase order (1-16) for implementation
3. Complete phase checkpoint before moving to next phase

## Key Principles

- **Atomic Commits**: 1 task = 1 commit
- **Size Limit**: 1-5 files per task
- **TDD Required**: Red-Green-Refactor cycle
- **Explicit Dependencies**: Deliverables tracked between tasks
- **Verification Level**: Each task specifies L1/L2/L3

## Common Processing (Implemented Once)

- Authentication Middleware (Task 07)
- Error Response Format (Task 06)
- Design Tokens (Task 09)
- i18n Hook (Task 11)
- Signed URL Generation (Task 03)
- SLO Monitoring (Task 21)

## Notes

- Tasks 01-08 can be completed by one team member
- Tasks 09-18 can be completed in parallel by frontend team
- Tasks 19-21 can be completed in parallel by AI/backend team
- After Task 21, feature tasks can proceed in parallel
- Testing tasks (45-48) can be developed alongside features

## Getting Started

```bash
# Read the overview
cat _overview-diarlies-mvp.md

# Start with Phase 1
cat diarlies-mvp-task-01.md

# Track progress
# Use checkboxes in each task file and phase completion files
```
