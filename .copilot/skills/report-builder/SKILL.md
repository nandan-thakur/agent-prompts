---
name: report-builder
description: >
  Build structured Markdown review reports with priority tables, findings summary,
  and merge recommendations. Use when generating code review output, architecture
  decision records, or any structured analysis report.
---

# Report Builder Skill

This skill helps you create structured Markdown reports for code reviews and analysis.

## When to Use
- Generating a final code review report from multiple reviewers
- Creating architecture decision records (ADRs)
- Building any structured analysis output with priorities and recommendations

## Report Template

### Code Review Report
```markdown
# Code Review: ${title}

> **PR**: #${number} | **Branch**: `${head}` → `${base}`
> **Date**: ${date} | **Reviewed by**: ${agent_count} parallel agents

## 📁 Files Reviewed
| File | Type | Changes |
|------|------|---------|
| `path/to/file.tsx` | Component | +25 / -10 |

---

## Findings by Domain

### [Domain Emoji] [Domain Name]

#### [Finding Emoji] [Concise Title]
* **Priority**: 🔥 Critical / ⚠️ High / 🟡 Medium / 🟢 Low
* **File**: `path/to/file.tsx`
* **Details**: Clear explanation of the issue
* **Suggested Change**:
  ```tsx
  // Before
  // After
  ```

---

## 📋 Summary Table

| # | Priority | Finding | Domain | File |
|---|:--------:|---------|--------|------|
| 1 | 🔥 | ... | Security | `...` |
| 2 | ⚠️ | ... | React | `...` |

## 🏥 Health Score

| Metric | Score |
|--------|-------|
| Security | 🟢 / 🟡 / 🔥 |
| Performance | 🟢 / 🟡 / 🔥 |
| Accessibility | 🟢 / 🟡 / 🔥 |
| Code Quality | 🟢 / 🟡 / 🔥 |

**Overall**: 🟢 Good / 🟡 Needs work / 🔥 Requires fixes

**Recommendation**: ✅ Approve / 🔄 Request changes / 🚫 Block
```

## Emoji Legend
| Emoji | Meaning |
|-------|---------|
| 🔧 | Change request |
| ❓ | Question |
| ⛏️ | Nitpick |
| ♻️ | Refactor suggestion |
| 💭 | Concern |
| 👍 | Positive note |
| 📝 | Note |
| 🌱 | Future improvement |

## Priority Rules
1. 🔥 **Critical** — Must fix before merge (security vulnerabilities, data loss, crashes)
2. ⚠️ **High** — Should fix before merge (accessibility, major bugs)
3. 🟡 **Medium** — Recommended (performance, maintainability)
4. 🟢 **Low** — Nice to have (nitpicks, style preferences)

Sort summary table by priority (🔥 first, 🟢 last).
