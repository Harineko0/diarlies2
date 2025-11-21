## Google ADK starter (uv)

This directory hosts a minimal Google ADK agent scaffold managed with `uv`.

### Setup

```bash
uv sync --all-groups
```

### Run the agent

- CLI: `uv run adk run agents/hello`
- Dev UI: `uv run adk web agents/hello --port 8080`

Ensure `GOOGLE_API_KEY` (or Vertex credentials) is set before invoking the agent.

### Tooling

- Lint: `uv run ruff check .`
- Format check: `uv run black --check .`
- Tests: `uv run pytest`
- Build: `uv build`
