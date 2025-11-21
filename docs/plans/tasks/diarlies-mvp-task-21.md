# Task 21: Gemini API Integration and SLO Monitoring

Metadata:
- Phase: 6 (AI Agent Foundation)
- Dependencies: Task 20 → Vertex AI configuration
- Provides:
  - Gemini 2.5 Flash client
  - Gemini 3 Pro Image client
  - SLO monitoring wrapper
- Size: Medium (3-4 files)
- Verification: L2 (Tests Pass)

## Implementation Content
Integrate Gemini API clients with SLO monitoring, retry logic, and error handling for text and image generation.

## Target Files
- [ ] `apps/ai-agent/agent/gemini/text_client.py`
- [ ] `apps/ai-agent/agent/gemini/image_client.py`
- [ ] `apps/ai-agent/agent/gemini/slo_monitor.py`
- [ ] `apps/ai-agent/tests/test_gemini_integration.py`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_ai_agent.md SLO requirements (3s text, 10s image)
- [ ] Write test for text generation under 3s
- [ ] Write test for image generation monitoring
- [ ] Write test for retry logic
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create SLO monitoring wrapper:
  ```python
  # agent/gemini/slo_monitor.py
  import time
  import logging
  from functools import wraps

  class SLOMonitor:
      def __init__(self, target_seconds: float):
          self.target_seconds = target_seconds
          self.logger = logging.getLogger(__name__)

      def monitor(self, func):
          @wraps(func)
          def wrapper(*args, **kwargs):
              start = time.time()
              try:
                  result = func(*args, **kwargs)
                  duration = time.time() - start

                  if duration > self.target_seconds:
                      self.logger.warning(
                          f"{func.__name__} exceeded SLO: {duration:.2f}s > {self.target_seconds}s"
                      )
                      return {"status": "long_running", "duration": duration}

                  return result
              except Exception as e:
                  duration = time.time() - start
                  self.logger.error(f"{func.__name__} failed after {duration:.2f}s: {e}")
                  raise
          return wrapper
  ```
- [ ] Create text generation client:
  ```python
  # agent/gemini/text_client.py
  from vertexai.generative_models import GenerativeModel
  from .slo_monitor import SLOMonitor

  class TextGenerationClient:
      def __init__(self):
          self.model = GenerativeModel("gemini-2.5-flash")
          self.slo = SLOMonitor(target_seconds=3.0)

      @property
      def monitored_generate(self):
          return self.slo.monitor(self._generate)

      def _generate(self, prompt: str, language: str) -> str:
          response = self.model.generate_content(
              prompt,
              generation_config={"language": language}
          )
          return response.text
  ```
- [ ] Create image generation client:
  ```python
  # agent/gemini/image_client.py
  from vertexai.generative_models import GenerativeModel
  from .slo_monitor import SLOMonitor

  class ImageGenerationClient:
      def __init__(self):
          self.model = GenerativeModel("gemini-3-pro-image")
          self.slo = SLOMonitor(target_seconds=10.0)

      @property
      def monitored_generate(self):
          return self.slo.monitor(self._generate)

      def _generate(self, prompt: str, art_style: str) -> bytes:
          response = self.model.generate_content(
              prompt,
              generation_config={"style": art_style}
          )
          return response.image_data
  ```
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Add retry logic with exponential backoff
- [ ] Extract common Gemini configuration
- [ ] Add comprehensive error messages

## Completion Criteria
- [ ] Text generation client working with SLO monitoring
- [ ] Image generation client working with SLO monitoring
- [ ] SLO violations logged appropriately
- [ ] Retry logic functional
- [ ] Tests pass for both clients (L2)

## Deliverables for Dependent Tasks
- **Text Client**: For dialogue and text generation
- **Image Client**: For picture diary generation
- **SLO Monitor**: For tracking performance

## Notes
- Text SLO: 3 seconds target
- Image SLO: 10 seconds target (return long_running if exceeded)
- Impact scope: All AI generation features
- Constraints: Must use specified Gemini models
