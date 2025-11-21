# Section 2: System Architecture and Backend

This section defines the system's runtime architecture, component roles, and API design principles.

## 1. System Architecture

The architecture follows a standard client-server pattern with a dedicated AI Agent layer for complex decision-making and orchestration.

### Architectural Diagram (Mermaid)

```mermaid
graph LR
    subgraph Frontend (Next.js)
        A[Browser/User] --> B(UI/UX)
        B --> C{API Request}
    end

    subgraph Backend (Go)
        C --> D(Go API Gateway)
        D --> E{Auth Check: better-auth}
        E --> F{Request Handler}
    end

    subgraph AI/Data Services (Google Cloud)
        F --> G(AI Agent: ADK + Vertex AI)
        G --> H(Gemini API: 2.5 Flash / 3 Pro)
        G <--> I(Cloud SQL: Data/Style Learning)
        G <--> J(Cloud Storage: Image Files)
        F --> K(Google Maps Platform)
    end

    subgraph Infrastructure
        L[Terraform] --> M(All Cloud Resources Deployment)
    end
````

## 2\. Component Responsibilities

| Component | Key Responsibilities |
| :--- | :--- |
| **Next.js Frontend** | UI rendering, state management, i18n, theme management (Dark/Light), Google Maps integration (client-side location gathering). |
| **Go Backend** | API routing, input validation, authentication (via better-auth), initiating AI Agent workflows, managing database transactions (read/write), enforcing SLO-aware retries/fallbacks. |
| **AI Agent Layer (Python ADK)** | **Workflow Orchestration (The Brain):** Manages multi-turn dialogue, prompt engineering using language and style data, calling multiple Gemini models, and managing image generation steps. |

## 3\. API Design Principles (Go Backend)

* **RESTful Approach:** APIs will be designed following REST principles (e.g., `/api/v1/diaries`, `/api/v1/user/style`).
* **Performance/SLOs:** Go's concurrency will be leveraged, especially for endpoints that call the AI Agent, which may have higher latency. Text generation targets 3s SLO; image generation targets 10s SLO. If image generation exceeds 10s, the backend returns a "long-running" state so the frontend can show `Generation takes long time. Retry?` with a text-button trigger to re-request.
* **Error Handling:** On Gemini or agent errors, return friendly error payloads; retry once where idempotent. If style data is missing, skip priming and proceed with defaults, but log the miss.
* **Security/Networking:** All endpoints are secured via better-auth. Services use service accounts with least privilege and private networking (Cloud Run with VPC connector to Cloud SQL private IP; agent service likewise) to reach SQL/Storage. Signed URLs are short-lived for media access.
