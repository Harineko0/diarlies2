# Task 24: Text Generation Flow Integration

Metadata:
- Phase: 7 (Dialogue & Text Generation)
- Dependencies: Tasks 22, 23 → Dialogue endpoint and UI
- Provides:
  - Complete text generation flow
  - Text display with editing capability
- Size: Medium (3 files)
- Verification: L1 (User-facing Feature)

## Implementation Content
Integrate AI-generated diary text display with user editing capabilities, completing the dialogue-to-text generation flow.

## Target Files
- [ ] `apps/web/app/diary/create/text-generation/page.tsx`
- [ ] `apps/web/components/diary/GeneratedText.tsx`
- [ ] `apps/web/components/diary/GeneratedText.test.tsx`

## Implementation Steps (TDD: Red-Green-Refactor)

### 1. Red Phase
- [ ] Review designdoc_ai_agent.md text generation workflow
- [ ] Write test for text generation page rendering
- [ ] Write test for displaying AI-generated text
- [ ] Write test for text editing functionality
- [ ] Run tests and confirm failure

### 2. Green Phase
- [ ] Create text generation page:
  ```tsx
  // app/diary/create/text-generation/page.tsx
  'use client';

  import { useEffect, useState } from 'react';
  import { GeneratedText } from '@/components/diary/GeneratedText';
  import { useDialogueContext } from '@/contexts/DialogueContext';

  export default function TextGenerationPage() {
    const { dialogueData, generateText } = useDialogueContext();
    const [generatedText, setGeneratedText] = useState('');
    const [isGenerating, setIsGenerating] = useState(false);

    useEffect(() => {
      async function generate() {
        setIsGenerating(true);
        try {
          const text = await generateText(dialogueData);
          setGeneratedText(text);
        } catch (error) {
          // Handle error
        } finally {
          setIsGenerating(false);
        }
      }
      generate();
    }, []);

    return (
      <div className="container">
        {isGenerating ? (
          <div className="brutal-border">
            <p className="font-mono">// GENERATING DIARY TEXT...</p>
          </div>
        ) : (
          <GeneratedText
            text={generatedText}
            onEdit={setGeneratedText}
          />
        )}
      </div>
    );
  }
  ```
- [ ] Create GeneratedText component:
  ```tsx
  // components/diary/GeneratedText.tsx
  import { useState } from 'react';

  interface Props {
    text: string;
    onEdit: (text: string) => void;
  }

  export function GeneratedText({ text, onEdit }: Props) {
    const [isEditing, setIsEditing] = useState(false);
    const [editedText, setEditedText] = useState(text);

    return (
      <div className="brutal-border p-4">
        {isEditing ? (
          <textarea
            className="w-full min-h-[300px] font-mono brutal-border"
            value={editedText}
            onChange={(e) => setEditedText(e.target.value)}
          />
        ) : (
          <p className="font-mono whitespace-pre-wrap">{text}</p>
        )}

        <div className="mt-4 flex gap-4">
          <button
            className="brutal-border px-4 py-2"
            onClick={() => {
              if (isEditing) {
                onEdit(editedText);
              }
              setIsEditing(!isEditing);
            }}
          >
            {isEditing ? 'SAVE' : 'EDIT'}
          </button>

          {!isEditing && (
            <button
              className="brutal-border px-4 py-2"
              onClick={() => {/* Navigate to image generation */}}
            >
              CONTINUE TO IMAGES
            </button>
          )}
        </div>
      </div>
    );
  }
  ```
- [ ] Run tests and confirm they pass

### 3. Refactor Phase
- [ ] Extract loading state component
- [ ] Add error boundary
- [ ] Improve accessibility (ARIA labels)

## Completion Criteria
- [ ] Text generation initiates on page load
- [ ] AI-generated text displays correctly
- [ ] Edit mode toggles successfully
- [ ] Text updates saved
- [ ] Loading state shows Brutalist design
- [ ] All tests pass (L2)
- [ ] Operation verified: User can generate and edit diary text (L1)

## Deliverables for Dependent Tasks
- **Generated Text Component**: Reusable for review page
- **Text Generation Flow**: Complete dialogue → text pipeline

## Notes
- Text must be editable per R3.1 requirement
- 3-second SLO monitored on backend
- Impact scope: Core diary creation feature
- Constraints: Must follow Brutalism design
