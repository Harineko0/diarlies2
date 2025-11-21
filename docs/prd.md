# Product Requirements Document (PRD)

## AI-Powered Picture Diary Web Application

| Key Information | Detail |
| :--- | :--- |
| **Product Name** | AI-Powered Picture Diary (Tentative) |
| **Version** | 1.0 (MVP) |
| **Target Audience** | Users seeking an effortless way to keep a daily diary with creative AI-generated visuals. |
| **Status** | Finalized Requirements |
| **Date** | November 21, 2025 |

---

## 1. Goal and Vision

The goal is to create a delightful and easy-to-use web application where users can quickly record their daily experiences. The AI will transform these inputs into personalized, written and illustrated diary entries, with the system actively learning the user's writing style over time.

---

## 2. Technical Stack and AI Models

The application will leverage Google Cloud services and specific AI models as requested for performance, scalability, and specific generation capabilities. **The use of an AI Agent Development Kit (ADK)** is strongly recommended for managing complex workflows, model orchestration, and the learning mechanism.

| Component | Technology / Model | Rationale |
| :--- | :--- | :--- |
| **Text Generation / Dialog** | **Gemini 2.5 Flash** | Fast response time is crucial for the interactive dialogue and initial diary text generation. |
| **Image Generation** | **Gemini 3 Pro Image Preview** | Required for high-quality, diverse visual styles (e.g., 4-panel manga, watercolor) and complex scene interpretation. |
| **Database (Structured Data)** | **Google Cloud SQL** | Storing user data, diary entries, and structured language/style learning data. |
| **File Storage** | **Cloud Storage** | Storing uploaded user images and generated AI picture diary images. |
| **Authentication** | **better-auth** | Handling user sign-up, login, and authorization. |

---

## 3. Detailed Feature Requirements

### 3.1. User Input & Data Collection (Focus on Ease-of-Use)

The input process must prioritize simplicity and selection over free-form text input.

| ID | Feature | Requirements |
| :--- | :--- | :--- |
| **R1.1** | **Interactive Dialogue** | AI initiates the dialogue (using Gemini 2.5 Flash) by asking about the user's day. |
| **R1.2** | **Selection-Based Input** | User input should be guided by **selection options** (e.g., categories like Work, Hobby, Food) wherever possible, in addition to free text. |
| **R1.3** | **Location Input** | Location must be easily selectable via a **Zoom & Tap Map Interface**. The system must capture latitude, longitude, and place name. |
| **R1.4** | **Image Upload** | Standard **Upload Button** to allow users to select and upload images from their local file system (stored in Cloud Storage). |
| **R1.5** | **Style Configuration** | Users must pre-select the desired **Writing Tone** (e.g., Casual, Poetic) and **Art Style** (e.g., Watercolor, Anime) before generation. |

### 3.2. AI Generation

The system must orchestrate multiple steps and models to generate the final diary entry.

| ID | Feature | Requirements |
| :--- | :--- | :--- |
| **R2.1** | **Diary Text Generation** | Gemini 2.5 Flash generates the full diary text based on the user's input, location, and preferred writing style (R1.5). |
| **R2.2** | **Picture Generation** | Gemini 3 Pro Image Preview generates **multiple picture patterns** based on the generated text (R2.1) and the selected art style (R1.5). |
| **R2.3** | **Picture Patterns** | Generated image options must include different formats, such as a **4-Panel Comic Strip** and a **Colored Pencil/Sketch style**. |

### 3.3. Review, Learning, and Management (The Learning Loop)

This section defines the core mechanism for personalization.

| ID | Feature | Requirements |
| :--- | :--- | :--- |
| **R3.1** | **Editable Final Text** | Users must be able to **freely modify/edit** the AI-generated diary text before saving. |
| **R3.2** | **User Style Learning** | Upon saving, the **user's final, corrected text** must be stored in Cloud SQL as "User-Specific Style Data," separate from the AI's original output. |
| **R3.3** | **Style Adaptation** | The AI Agent (ADK) must retrieve this User-Specific Style Data and incorporate it into the prompt for **subsequent diary generations** (R2.1) to align the AI's output with the user's personal writing style. |
| **R3.4** | **Image Selection** | Users must select one of the generated picture patterns (R2.2) to be the final image for the diary entry. |
| **R3.5** | **Calendar View** | Users can browse past entries via a calendar interface. |

### 3.4. Multi-Language Support (Localization)

The application must support multiple languages, with a strict linkage between UI language and generated content language.

| ID | Feature | Requirements |
| :--- | :--- | :--- |
| **R4.1** | **Language Setting** | Users must select their preferred language for the application (e.g., English, Japanese). This setting is stored in Cloud SQL. |
| **R4.2** | **UI Localization** | All static UI elements must reflect the selected language (R4.1). |
| **R4.3** | **Content Language Link** | The AI Agent must constrain the Gemini models to generate all diary text (R2.1) **in the user's selected language (R4.1)**, regardless of the language used in the initial input. |
| **R4.4** | **Language-Specific Learning**| User Style Learning Data (R3.2) must be stored and accessed **separately for each language**, preventing style mixing across different languages. |
