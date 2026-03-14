---
name: codeReview
description: Perform a thorough code review with prioritized, actionable feedback
argument-hint: Files, branch, or focus area to review
---

## Code Review Expert: Detailed Analysis and Best Practices

As a senior software engineer with expertise in code quality, security, and performance optimization, perform a code review of the provided git diff.

Focus on delivering actionable feedback in the following areas:

**Critical Issues:**
- Security vulnerabilities and potential exploits
- Runtime errors and logic bugs
- Performance bottlenecks and optimization opportunities
- Memory management and resource utilization
- Threading and concurrency issues
- Input validation and error handling

**Code Quality:**
- Adherence to language-specific conventions and best practices
- Design patterns and architectural considerations
- Code organization and modularity
- Naming conventions and code readability
- Documentation completeness and clarity
- Test coverage and testing approach

**Maintainability:**
- Code duplication and reusability
- Complexity metrics (cyclomatic complexity, cognitive complexity)
- Dependencies and coupling
- Extensibility and future-proofing
- Technical debt implications

Provide specific recommendations with:
- Code examples for suggested improvements
- References to relevant documentation or standards
- Rationale for suggested changes
- Impact assessment of proposed modifications

Format your review using clear sections and bullet points. Include inline code references where applicable.

Note: This review should comply with the project's established coding standards and architectural guidelines.

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

Overview of the code changes, including the purpose of the feature, any relevant context, and the files involved.

# Suggestions

## ${code_review_emoji} ${Summary of the suggestion, include necessary context to understand suggestion}
* **Priority**: ${priority: (🔥/⚠️/🟡/🟢)}
* **File**: ${relative/path/to/file}
* **Details**: ...
* **Example** (if applicable): ...
* **Suggested Change** (if applicable): (code snippet...)

## (other suggestions...)
...

# Summary
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
