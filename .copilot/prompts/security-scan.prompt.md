---
name: security-scan
description: Security-focused scan of current changes — XSS, injection, auth, data leaks
agent: 'ask'
model: Claude Sonnet 4.6 (copilot)
tools: ['read', 'search', 'githubRepo']
---

Perform a **security-focused review** of the current changes or PR #${input:prNumber:Enter PR number or leave blank for current branch}.

## Focus Areas
1. **XSS & Injection**: `dangerouslySetInnerHTML`, dynamic `href`/`src`, `eval()`, unsanitized input
2. **Auth & Data Leakage**: client-side auth checks, tokens in localStorage, API keys in code, PII in logs
3. **Memory Leaks**: missing `useEffect` cleanup, uncancelled fetches, open connections
4. **Input Validation**: unvalidated forms, file uploads without constraints
5. **Redux Security**: sensitive data exposed via DevTools in production

## Output Format
For each vulnerability found:
- **Severity**: 🔥 Critical / ⚠️ High / 🟡 Medium
- **Type**: XSS / Injection / Data Leak / Memory Leak / Auth
- **File + Line**: exact location
- **Impact**: what could happen if exploited
- **Fix**: before/after code

🔥 Critical issues = **merge blocker**.
