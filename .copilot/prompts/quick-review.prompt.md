---
name: quick-review
description: Quick review of a single file or code selection — no full pipeline
agent: 'ask'
model: Claude Sonnet 4.6 (copilot)
tools: ['read', 'search']
---

Review the currently open file or selection for the **top 5** most impactful issues.

Check for:
1. **Security** — XSS, unsafe patterns, data leaks
2. **React** — hooks correctness, stale closures, key prop issues
3. **Performance** — unnecessary re-renders, missing memoization
4. **Accessibility** — missing ARIA, keyboard traps, semantic HTML
5. **Code quality** — TypeScript `any` types, dead code, naming

For each finding:
- **Priority**: 🔥 / ⚠️ / 🟡 / 🟢
- **Line**: reference the specific line
- **Fix**: show before/after code

Keep it concise — this is a quick check, not a full review.
