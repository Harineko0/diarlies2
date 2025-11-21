# Section 3: AI Agent Workflow and Learning

This section details the critical role of the ADK/Vertex AI Agent and the implementation of the style learning and multilingual logic.

## 1. AI Agent Core Workflow

The AI Agent orchestrates the entire diary creation process (R2.1, R2.2), ensuring consistency across models and data sources.

### Step-by-Step Generation Flow:
1.  **Retrieve Constraints:** Agent fetches `user_id`, `language_code`, `writing_tone`, and `art_style` from the Go backend.
2.  **Retrieve Style Data (R3.3, R4.4):** Agent queries the **`user_style_data` table (Cloud SQL)** via a custom tool/knowledge base in Vertex AI Agent Builder, filtering strictly by the user's ID AND the current `language_code`.
3.  **Dialogue/Input:** Agent uses **Gemini 2.5 Flash** with the retrieved style constraints to conduct interactive dialogue and gather detailed event data.
4.  **Text Generation:** Agent constructs the final prompt, injecting style fragments and constraint instructions (R4.3: "Generate text in {language_code}"), and requests the final diary draft.
5.  **Image Prompt Engineering:** Agent translates the generated text into detailed image prompts, strictly adhering to the user's `art_style` (R1.5) and the required patterns (4-panel comic).
6.  **Image Generation:** Agent calls **Gemini 3 Pro Image Preview** to generate multiple options, saving results to Cloud Storage (R2.2, R3.4). Target SLO is 10 seconds; if exceeded, the agent marks the request as long-running so the frontend can show `Generation takes long time. Retry?` with a text-button to retry.

## 2. User Style Learning Mechanism

The system learns from the user's corrections (R3.2) to personalize the AI's output (R3.3).

| Process | Requirement | Implementation |
| :--- | :--- | :--- |
| **Commit/Save (R3.2)** | User's final edited text must be saved as the source for learning. | Go Backend triggers an Agent endpoint, which saves the `final_text` along with the `language_code` into the `user_style_data` table. |
| **Data Separation (R4.4)** | Learning data must be language-specific. | The `user_style_data` table includes a `language_code` column. The Agent only retrieves data matching the current language (R3.3). |
| **Application (R3.3)** | The Agent must apply this historical style data to the prompt for future generations. | The Agent uses the retrieved `style_fragment` from Cloud SQL to "prime" the Gemini 2.5 Flash model before generation. |

## 3. Multilingual Implementation (R4)

All interaction and generation must align with the user's stored `language_code`.

* **Frontend:** The UI displays strings based on the `language_code` (R4.2).
* **AI Agent:** Every single call to Gemini 2.5 Flash and every prompt to Gemini 3 Pro Image Preview must include a hard constraint specifying the target `language_code` (R4.3).

## 4. Reliability and Error Handling

* **Text SLO:** Target completion under 3 seconds; if exceeded, return partial progress status to backend (no frontend retry UI required).
* **Image SLO:** Target 10 seconds; if breached, return "long-running" status so UI can prompt retry. Backend/agent must dedupe repeated retry requests to avoid duplicate image jobs/charges.
* **Style Data Miss:** If no `user_style_data` rows for the `(user_id, language_code)` pair, proceed without priming but log the miss.
* **Gemini/Tool Errors:** Retry once on transient errors; otherwise forward a friendly, localized error message to the backend for display.
