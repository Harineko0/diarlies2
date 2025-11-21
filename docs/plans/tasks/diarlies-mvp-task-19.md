# Task 19: Python ADK Setup and Project Structure

Metadata:
- Phase: 6 (AI Agent Foundation)
- Dependencies: Tasks 01, 05 → GCP project, Database schema
- Provides:
  - Python ADK project structure
  - ADK configuration
  - Agent base classes
- Size: Medium (4-5 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Set up Python Agent Development Kit (ADK) project structure for orchestrating the AI-powered diary generation workflow.

## Target Files
- [ ] `apps/ai-agent/requirements.txt`
- [ ] `apps/ai-agent/main.py`
- [ ] `apps/ai-agent/agent/config.py`
- [ ] `apps/ai-agent/agent/base_agent.py`
- [ ] `apps/ai-agent/tests/test_agent_init.py`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_ai_agent.md agent workflow requirements
- [ ] Research ADK documentation and examples
- [ ] Write test for agent initialization
- [ ] Write test for configuration loading
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create `requirements.txt`:
  ```
  google-cloud-aiplatform>=1.38.0
  vertexai>=1.38.0
  google-cloud-sql-python-connector>=1.4.0
  sqlalchemy>=2.0.0
  python-dotenv>=1.0.0
  pytest>=7.4.0
  ```
- [ ] Create project structure:
  ```
  apps/ai-agent/
  ├── requirements.txt
  ├── main.py
  ├── agent/
  │   ├── __init__.py
  │   ├── config.py
  │   ├── base_agent.py
  │   └── workflows/
  │       └── __init__.py
  ├── tools/
  │   └── __init__.py
  └── tests/
      └── test_agent_init.py
  ```
- [ ] Create configuration:
  ```python
  # agent/config.py
  from dataclasses import dataclass
  import os

  @dataclass
  class AgentConfig:
      project_id: str
      location: str
      db_connection_string: str

      @classmethod
      def from_env(cls):
          return cls(
              project_id=os.getenv("GCP_PROJECT_ID"),
              location=os.getenv("GCP_REGION", "us-central1"),
              db_connection_string=os.getenv("DB_CONNECTION_STRING")
          )
  ```
- [ ] Create base agent class:
  ```python
  # agent/base_agent.py
  from vertexai import agent_builder
  from .config import AgentConfig

  class DiaryAgent:
      def __init__(self, config: AgentConfig):
          self.config = config
          self.agent = None

      def initialize(self):
          """Initialize Vertex AI Agent"""
          pass
  ```
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Add logging configuration
- [ ] Extract common agent utilities
- [ ] Document agent initialization flow

## Completion Criteria
- [ ] Python project structure created
- [ ] Dependencies installed successfully
- [ ] Agent configuration loads from environment
- [ ] Base agent class initializes
- [ ] Tests pass for initialization (L2)

## Deliverables for Dependent Tasks
- **ADK Structure**: Foundation for agent workflows
- **Config Module**: For agent configuration
- **Base Agent**: For extending in workflow tasks

## Notes
- Python 3.10+ required for ADK
- Impact scope: All AI generation features
- Constraints: Must use Vertex AI Agent Builder
