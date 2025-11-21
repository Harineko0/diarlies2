# Section 1: UI/UX and Brutalism Design

This section details the design implementation, focusing on the strict application of Brutalism principles and the theme configuration.

## 1. Design Principles (Brutalism Implementation)

The design will be functional, stark, and structured, adhering to the following rules:

| Characteristic | Implementation Detail |
| :--- | :--- |
| **Thick Border Effect** | Every interactive element (buttons, cards, inputs) and main containers must feature **thick, distinct black outlines**. This border must be accompanied by a **simple, offset shadow layer (1-2px shift)** to the bottom-right, giving the element a pronounced 3D/cut-out appearance. |
| **Subtle Rounded Corners** | Corners on main windows, containers, buttons, and image previews will be **subtly or moderately rounded** (e.g., 4-8px radius) to soften the harshness of the thick borders without looking modern. |
| **Typography** | Use a **monospaced** or bold, functional sans-serif font throughout the application to enhance the exposed, functional aesthetic. Text should be high contrast against backgrounds. |
| **Containers and Outlines** | Every major UI component must be explicitly contained within these thick, offset borders, mimicking exposed structural elements. |
| **Color Palette** | Simple, flat colors for backgrounds. **High-contrast, saturated colors** (e.g., neon yellow, electric blue) are reserved exclusively for **interactive states and highlights**. |
| **Layout** | Layouts can be asymmetrical or layered to create visual depth and intentional imbalance, breaking from traditional smooth grid alignment. |
| **Exposed/Unfinished Look** | UI should avoid glossy effects, complex gradients, or overly smooth transitions. |

## 2. Theme Configuration

| Feature | Requirement |
| :--- | :--- |
| **Default Theme** | The application must load the **Light Theme** by default, aligning with standard system settings initially. |
| **Theme Toggle** | A prominent, brutally styled **Toggle Button** (e.g., Sun/Moon icon within a thick border) must be present in the persistent header for instantaneous switching between Light and Dark themes. |
| **Dark Theme** | Dark Theme must utilize a deep gray or black background with white/light gray primary text, maintaining high contrast and applying the same thick, offset black borders (which may need a white/light outline on the dark background for visibility). |

## 3. Component-Specific Requirements

| Page | Component/Action | Brutalism Design Notes |
| :--- | :--- | :--- |
| **Input Page** | **Selection Buttons (R1.2)** | Square or subtly rounded buttons with the **thick border effect**. Selected state uses a flat, high-contrast background color. |
| **Input Page** | **Map Interface (R1.3)** | Google Maps Platform component styled with a **high-contrast, minimal theme** to fit the aesthetic. The location pin must be a simple, square, **highlight-colored** marker. |
| **Review Page** | **Editable Text Area (R3.1)** | Text area uses a distinctive thick, maybe double-layered border. Focus/Edit state is indicated by a jarring, high-contrast color flash or animation. |
| **All Pages** | **Buttons (General)** | Large, rectangular buttons. Hover state must trigger an **instantaneous (no transition)** background color change to a highlight color. |
| **All Pages** | **Loading** | Loading screens feature minimal graphics and **glitching monospaced text** (e.g., `// AWAITING GEMINI RESPONSE...`) rather than complex spinners. |
