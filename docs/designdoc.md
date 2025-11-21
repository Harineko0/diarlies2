# Design Document: AI-Powered Picture Diary Web Application

## 1. Overview and Goals

This document defines the technical specifications, architectural decisions, and design requirements for the AI-Powered Picture Diary Web Application. The core goal is to deliver a highly personalized, multilingual diary experience with a focus on ease of input and a distinct, functional aesthetic.

The application leverages advanced Google AI models and a robust cloud infrastructure to learn the user's writing style and generate creative, illustrated diary entries based on minimal input.

## 2. Finalized Technology Stack

The application uses a modern, high-performance stack hosted on Google Cloud, managed via Infrastructure as Code (IaC).

| Category | Technology / Model | Rationale |
| :--- | :--- | :--- |
| **Frontend** | **Next.js (React)** | High performance, server-side rendering capability, and robust tooling for i18n and component development. |
| **Backend** | **Go (Golang)** | High concurrency, performance, and efficiency for API routing and interaction with cloud services/AI agents. |
| **AI Agent** | **ADK (Python) + Vertex AI Agent Builder** | Orchestration of complex, multi-step workflows, prompt engineering, and external tool (database/knowledge base) integration. |
| **LLM (Text/Dialog)** | **Gemini 2.5 Flash** | Crucial for high-speed, interactive dialogue and text generation. |
| **LLM (Image)** | **Gemini 3 Pro Image Preview** | Required for high-quality, stylized picture diary generation. |
| **Database** | **Google Cloud SQL (PostgreSQL)** | Structured data persistence, including learning data, with strong relational integrity. |
| **Storage** | **Cloud Storage** | Durable and scalable storage for large media files (user uploads, generated images). |
| **Authentication** | **better-auth** | Third-party service for robust user authentication and session management. |
| **Infrastructure** | **Terraform** | IaC for managing and deploying all Google Cloud resources efficiently and repeatably. |
| **Mapping** | **Google Maps Platform** | Used for the zoom-and-tap location input feature. |

## 3. Section Breakdown

Detailed specifications for each component are provided in the respective files:
* [UI/UX and Brutalism Design](designdoc_uiux.md)
* [System Architecture and Backend](designdoc_architecture.md)
* [AI Agent Workflow and Learning](designdoc_ai_agent.md)
* [Data Structure and Storage](designdoc_data.md)
* [Terraform and Google Cloud Infrastructure](designdoc_infra.md)

## 4. Feature Requirements Summary (Referenced in all sections)

The design must satisfy the following key requirements:
1.  **Ease of Input:** Heavy reliance on selections and the map interface.
2.  **Multi-Language Support (R4):** UI language dictates the generated diary language.
3.  **User Style Learning (R3):** The system must save and apply user corrections to train the AI's writing style, segregated by language.
4.  **Brutalism Aesthetic:** All UI elements adhere to the specified Brutalism design principles.