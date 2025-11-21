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
| **Go Backend** | API routing, input validation, authentication (via better-auth), initiating AI Agent workflows, managing database transactions (read/write). |
| **AI Agent Layer (Python ADK)** | **Workflow Orchestration (The Brain):** Manages multi-turn dialogue, prompt engineering using language and style data, calling multiple Gemini models, and managing image generation steps. |

## 3\. API Design Principles (Go Backend)

* **RESTful Approach:** APIs will be designed following REST principles (e.g., `/api/v1/diaries`, `/api/v1/user/style`).
* **Performance:** Go's concurrency will be leveraged, especially for endpoints that call the AI Agent, which may have higher latency. Asynchronous processing for image generation may be considered for future optimization.
* **Security:** All endpoints must be secured via the better-auth layer. Input data must be strictly validated before transmission to the AI Agent or database.
