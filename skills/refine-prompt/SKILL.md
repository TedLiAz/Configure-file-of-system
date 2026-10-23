---
name: refine-prompt
description: Review, clarify, and optimize vague or brief user questions into structured, AI-ready prompts. Use when the user asks to review, optimize, or sharpen a question/prompt, or wants help structuring an inquiry for AI agents.
---

# Refine Prompt

Transform a raw, ambiguous, or brief user question into a high-leverage, structured prompt optimized for AI agents.

AI models perform best when instructions have explicit boundaries, grounded context, and clear acceptance criteria. This skill conducts an **ambiguity audit**, harvests missing facts from the local environment, and produces a **sharpened prompt**.

## Workflow

Follow these steps in sequence:

### 1. Ambiguity Audit

Examine the user's raw input along four core dimensions:

| Dimension | Audit Check | What's often missing |
| :--- | :--- | :--- |
| **Goal** | Is the primary objective singular, specific, and actionable? | High-level wishes ("make it better", "fix login") without target behavior. |
| **Context** | Are the tech stack, files, dependencies, and baseline stated? | Hidden assumptions about the current repository or environment. |
| **Constraints** | What are the negative bounds, performance, or styling limits? | Unspoken rules (e.g. "no new dependencies", "vanilla CSS", "must pass tests"). |
| **Acceptance** | How will the AI or user verify completion? | Missing verification step (e.g. test command, expected diff, visual output). |

### 2. Fact Harvesting (Environment First)

Do not ask the user for facts you can discover yourself.
- Check the workspace: inspect `package.json`, directory structure, git status, configuration files, and open files.
- Anchor file paths and technology versions using real project references.
- Only if a required architectural or product choice cannot be derived from code, formulate a targeted question.

### 3. Minimal Clarification (Only if Forked)

If critical decisions are unresolved and cannot be determined by code inspection:
- Keep questions to a minimum (maximum 2-3 questions in one round).
- Number each question and provide a **recommended default** so the user can just hit enter or confirm.

### 4. Structural Reconstruction

Reconstruct the raw input into the **AI-Optimized Structure**:

```markdown
### 🎯 Objective (目标)
[Single-sentence definition of what must be built, changed, or answered]

### 📂 Context & References (上下文与参考)
- **Tech Stack / Environment**: [Frameworks, runtimes, versions]
- **Target Files**: [Clickable links like `src/auth/login.ts`]
- **Current State**: [What exists right now / current behavior]

### 🛡️ Constraints & Rules (约束与边界)
- [Rule 1: e.g. Do not modify existing API contracts]
- [Rule 2: e.g. Follow existing coding conventions in the repo]
- [Rule 3: e.g. Performance / security / styling requirements]

### ✅ Acceptance Criteria (验收标准与交付物)
- [ ] [Criterion 1: Observable behavior or test passing]
- [ ] [Criterion 2: Expected output format (e.g., code diff, documentation)]
- [ ] [Criterion 3: Verification command to run]
```

### 5. Delivery & Execution

Present the response in two clean parts:
1. **Diagnosis & What Changed**: 2-3 bullet points highlighting what ambiguities were resolved and what context was injected.
2. **Sharpened Prompt**: The ready-to-run markdown block formatted with the structure above.
3. **Next Step**: Ask the user: *"Would you like me to execute this prompt directly now, or refine it further?"*
