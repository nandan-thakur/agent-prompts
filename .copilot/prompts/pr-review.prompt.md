---
name: pr-review
description: Full parallel PR review using all 7 specialist sub-agents
agent: 'Code Review'
argument-hint: '<PR number>'
tools: ['agent', 'githubRepo', 'runCommand', 'read', 'search']
---

Run a **full code review** on PR #${input:prNumber:Enter PR number or leave blank for current branch}.

Follow the Code Review orchestrator workflow:
1. Fetch the diff using `gh pr diff` (or local branch diff if no PR number)
2. Filter to frontend files only (`.tsx`, `.ts`, `.jsx`, `.js`, `.scss`, `.css`, `.module.scss`)
3. Run all 7 specialist sub-agents **in parallel**:
   - ⚛️ React & Component Design
   - 🔥 Security & Critical Issues
   - 🚀 Performance & Bundle
   - ♿ Accessibility (a11y)
   - 🎨 UI & Styling
   - 🧪 Testing & Code Quality
   - 🏗️ Frontend Architecture
4. Merge findings into a single report with priority summary table
5. Save the report to `./code-review-output.md`
