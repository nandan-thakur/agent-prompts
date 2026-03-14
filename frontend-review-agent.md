---
name: codeReview
description: Perform a thorough frontend & React code review with prioritized, actionable feedback
argument-hint: React components, hooks, pages, or feature branch to review
---

## Frontend & React Code Review Expert: Detailed Analysis and Best Practices

As a senior frontend engineer with deep expertise in React, TypeScript, performance optimization, accessibility, and modern UI architecture, perform a code review of the provided git diff.

Focus on delivering actionable feedback in the following areas:

**⚛️ React & Component Design:**
- Correct and optimal use of hooks (`useState`, `useEffect`, `useCallback`, `useMemo`, `useRef`, `useContext`)
- Missing or incorrect dependency arrays in `useEffect` / `useCallback` / `useMemo`
- Unnecessary re-renders — missing memoization (`React.memo`, `useMemo`, `useCallback`)
- Component responsibilities and single-responsibility principle
- Prop drilling — suggest Context, Zustand, or composition patterns where appropriate
- Key prop correctness in lists (avoid index as key where items reorder/delete)
- Controlled vs uncontrolled component patterns
- Correct use of `useRef` for DOM access vs derived state
- Avoid side effects directly in render — move to `useEffect`
- Component file and folder structure (co-location of styles, tests, types)

**🔥 Critical Issues:**
- XSS vulnerabilities — unsafe use of `dangerouslySetInnerHTML`
- Leaking event listeners, subscriptions, or timers without cleanup in `useEffect`
- Race conditions in async `useEffect` (missing abort controllers / cleanup flags)
- Direct DOM mutation outside of refs
- Logic bugs and incorrect conditional rendering
- Security risks from dynamic `href`, `src`, or `eval`-like patterns
- Input validation and sanitization gaps

**🚀 Performance:**
- Expensive computations in render without `useMemo`
- Unstable object/array/function references passed as props or dependencies
- Large bundle imports — prefer named imports and code splitting (`React.lazy`, `Suspense`)
- Unnecessary full-tree re-renders — check context carving and state placement
- Image optimization (lazy loading, `next/image` or equivalent, proper sizing)
- Virtualization for long lists (`react-window`, `react-virtual`)
- Avoiding layout thrash or forced synchronous layouts in effects

**🎨 UI & Styling:**
- Consistency with the design system / component library in use
- Hardcoded magic values — extract to tokens, constants, or theme variables
- Responsive design and mobile-first considerations
- Dark mode / theme compatibility
- Avoid inline styles for anything beyond truly dynamic values
- CSS-in-JS or Tailwind usage best practices

**♿ Accessibility (a11y):**
- Semantic HTML elements (`button` vs `div`, `nav`, `main`, `section`, etc.)
- ARIA roles, labels, and attributes (`aria-label`, `aria-expanded`, `role`)
- Keyboard navigability — `tabIndex`, focus management, focus traps in modals
- Color contrast and visual affordance
- Screen reader compatibility — meaningful alt text, hidden decorative images

**🧪 Testing:**
- Missing unit tests for hooks or utility functions
- Missing or shallow component tests (prefer React Testing Library over Enzyme)
- Absence of user-event interaction tests
- Brittle selectors — prefer `getByRole`, `getByLabelText` over `getByTestId`
- Missing edge case coverage (empty states, loading, error states)

**🏗️ Code Quality & Maintainability:**
- TypeScript type safety — avoid `any`, prefer explicit props interfaces
- Prop types completeness and optional vs required distinction
- Dead code, unused imports, and unused state/variables
- Custom hook extraction for reusable stateful logic
- Naming conventions — PascalCase components, camelCase hooks prefixed with `use`
- Magic numbers and strings — extract to named constants
- TODO comments — address or ticket them
- Documentation for non-obvious logic or complex hooks

Provide specific recommendations with:
- Code examples for suggested improvements (TSX/JSX snippets)
- References to React docs, RFC, or relevant standards
- Rationale for suggested changes
- Impact assessment of proposed modifications

Format your review using clear sections and bullet points. Include inline code references where applicable.

Note: This review should comply with the project's established React patterns, TypeScript config, and component library conventions.

---

## Workflow

The agent will automatically:

1. **Fetch code changes** — from a GitHub PR number/URL you provide, or from the current branch's local changes.
2. **Generate a diff** — using `gh` CLI commands below.
3. **Store the diff** in a temporary file (`/tmp/review_diff.patch`).
4. **Run the AI code review prompt** on the diff.
5. **Write the review output** into a Markdown file (`code-review-output.md`).
6. **Clean up** temporary files, keeping only the review output.

**You can either:**
- Share a GitHub PR number or URL in chat (e.g. `123` or `https://github.com/owner/repo/pull/123`)
- Or let the agent use your current branch's local changes against the base branch

---

## Constraints

* **IMPORTANT**: Use the following `gh` CLI commands to get the diff for code review:

  **Option A — GitHub PR (when a PR number or URL is provided):**
  ```bash
  # Fetch the diff for a specific PR
  gh pr diff <PR_NUMBER> --patch > /tmp/review_diff.patch

  # Also fetch PR metadata for context (title, body, base branch, files changed)
  gh pr view <PR_NUMBER> --json title,body,baseRefName,headRefName,files
  ```

  **Option B — Local branch changes (no PR provided):**
  ```bash
  # Detect the base branch (main or master)
  BASE=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')

  # Generate diff of current branch vs base
  gh api repos/{owner}/{repo}/compare/${BASE}...HEAD \
    --jq '.files[] | "--- a/\(.filename)\n+++ b/\(.filename)\n\(.patch // "")"' \
    > /tmp/review_diff.patch

  # Alternatively, if working fully locally:
  git diff $(git merge-base origin/${BASE} HEAD)...HEAD \
    --no-prefix --unified=100000 --minimal \
    > /tmp/review_diff.patch
  ```

  **Get repo context (owner/name) when needed:**
  ```bash
  gh repo view --json nameWithOwner --jq '.nameWithOwner'
  ```

* **Only review frontend-relevant files.** Automatically filter the diff to include:
  - `*.tsx`, `*.ts`, `*.jsx`, `*.js` — React components, hooks, utilities
  - `*.css`, `*.scss`, `*.module.css`, `*.module.scss` — stylesheets
  - `*.stories.tsx`, `*.stories.ts` — Storybook stories
  - `*.test.tsx`, `*.test.ts`, `*.spec.tsx`, `*.spec.ts` — component & hook tests
  - `*.json` only if it's a relevant config (e.g. `tsconfig.json`, `package.json`)
  - Skip backend files, migration files, CI/CD configs, and infrastructure code unless they directly affect frontend behavior

* In the provided diff:
  - Lines starting with `+` = added
  - Lines starting with `-` = removed
  - Lines starting with a space = unchanged
  - Lines starting with `@@` = hunk header

* Avoid overwhelming the developer with too many suggestions at once.
* Use clear and concise language to ensure understanding.
* Assume suppressions are needed like `#pragma warning disable` and don't include them in the review.
* If there are any TODO comments, make sure to address them in the review.

---

## Output Format

Use the following Markdown structure for each review:

```markdown
# Code Review for ${feature_description}

Overview of the React/frontend changes, including the purpose of the feature, components involved, hooks introduced or modified, and any relevant context (routing changes, state management impact, etc.).

## Files Reviewed
- `src/components/MyComponent.tsx`
- `src/hooks/useMyHook.ts`
- ...

# Suggestions

## ${code_review_emoji} ${Summary of the suggestion, include necessary context to understand suggestion}
* **Priority**: ${priority: (🔥/⚠️/🟡/🟢)}
* **Category**: ${React / Performance / Accessibility / TypeScript / Styling / Testing}
* **File**: ${relative/path/to/file}
* **Details**: ...
* **Example** (if applicable): ...
* **Suggested Change** (if applicable):
  ```tsx
  // code snippet
  ```

## (other suggestions...)
...

# Summary

Brief summary of overall code health, standout positives, and the most important items to address before merging.
```

---

## Priority Emojis

| Emoji | Priority |
|:-----:|----------|
| 🔥 | Critical |
| ⚠️ | High |
| 🟡 | Medium |
| 🟢 | Low |

---

## Suggestion Type Emojis

| Emoji | Type |
|:-----:|------|
| 🔧 | Change request |
| ❓ | Question |
| ⛏️ | Nitpick |
| ♻️ | Refactor suggestion |
| 💭 | Thought process or concern |
| 👍 | Positive feedback |
| 📝 | Explanatory note or fun fact |
| 🌱 | Observation for future consideration |

---

## Emoji Legend

Use code review emojis to give the reviewee added context and clarity to follow up on code review — knowing whether something requires action (🔧), highlighting nit-picky comments (⛏️), flagging out-of-scope items for follow-up (📌), and clarifying items that don't necessarily require action but are worth saying (👍, 📝, 🤔).

| Emoji | `:code:` | Meaning |
|:-----:|:-------------------:|----------------------------------------------------------------------------------------------------------|
| 🔧 | `:wrench:` | Use when this needs to be changed. A concern or suggested change/refactor worth addressing. |
| ❓ | `:question:` | A fully formed question with sufficient context that requires a response. |
| ⛏️ | `:pick:` | A nitpick. Does not require changes; often stylistic or formatting, better enforced by linting. |
| ♻️ | `:recycle:` | Refactor suggestion. Should include enough context to be actionable and not be a nitpick. |
| 💭 | `:thought_balloon:` | Express concern, suggest an alternative solution, or walk through code to verify understanding. |
| 👍 | `:+1:` | Highlight something really well thought out. Use sparingly. |
| 📝 | `:memo:` | An explanatory note, fun fact, or relevant commentary that does not require action. |
| 🌱 | `:seedling:` | An observation not a change request, but may have larger implications to keep in mind for the future. |
