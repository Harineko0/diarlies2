# Task 09: Design System Setup and Theme Configuration

Metadata:
- Phase: 3 (Frontend Foundation)
- Dependencies: None (independent frontend work)
- Provides:
  - Design tokens
  - Theme configuration
  - CSS utilities
- Size: Medium (3-4 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Implement Brutalism design system foundation with theme tokens, CSS variables, and configuration for light/dark modes.

## Target Files
- [ ] `apps/web/app/styles/tokens.css`
- [ ] `apps/web/app/styles/theme.css`
- [ ] `apps/web/lib/theme/ThemeProvider.tsx`
- [ ] `apps/web/lib/theme/theme.test.tsx`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_uiux.md Brutalism requirements
- [ ] Write test for theme provider rendering
- [ ] Write test for theme toggle functionality
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create design tokens in `styles/tokens.css`:
  ```css
  :root {
    /* Colors */
    --color-bg-light: #FFFFFF;
    --color-bg-dark: #0A0A0A;
    --color-text-light: #000000;
    --color-text-dark: #FFFFFF;
    --color-border: #000000;
    --color-highlight-yellow: #FFFF00;
    --color-highlight-blue: #00FFFF;

    /* Brutalism specific */
    --border-width: 3px;
    --border-radius: 6px;
    --shadow-offset: 4px;

    /* Typography */
    --font-mono: 'Courier New', monospace;
    --font-sans: 'Arial', sans-serif;
  }
  ```
- [ ] Create theme CSS with light/dark modes:
  ```css
  [data-theme="light"] {
    --bg: var(--color-bg-light);
    --text: var(--color-text-light);
    --border: var(--color-border);
  }

  [data-theme="dark"] {
    --bg: var(--color-bg-dark);
    --text: var(--color-text-dark);
    --border: var(--color-text-dark);
  }

  /* Brutalism utilities */
  .brutal-border {
    border: var(--border-width) solid var(--border);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow-offset) var(--shadow-offset) 0 var(--border);
  }
  ```
- [ ] Create ThemeProvider component
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Extract theme utilities
- [ ] Document token usage
- [ ] Add TypeScript types for theme values

## Completion Criteria
- [ ] Design tokens defined and documented
- [ ] Light and dark themes configured
- [ ] Theme provider working
- [ ] Tests pass for theme switching (L2)

## Deliverables for Dependent Tasks
- **Design Tokens**: Available for all components
- **Theme Provider**: For app-wide theme management
- **CSS Utilities**: Brutalism styles ready to use

## Notes
- Default to light theme as specified
- Impact scope: All UI components
- Constraints: Must follow Brutalism principles (thick borders, shadows, monospace)
