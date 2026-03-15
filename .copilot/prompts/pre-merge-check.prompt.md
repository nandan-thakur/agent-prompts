---
name: pre-merge-check
description: Final checklist before merging — CI, conflicts, critical issues, TODOs
agent: 'agent'
tools: ['runCommand', 'githubRepo', 'read', 'search']
---

Run a **pre-merge checklist** for PR #${input:prNumber:Enter PR number or leave blank for current branch}.

## Checklist

### 1. CI Status
```bash
gh pr checks ${prNumber}
```
Report: ✅ All passing / ❌ Failing checks (list them)

### 2. Merge Conflicts
```bash
gh pr view ${prNumber} --json mergeable --jq '.mergeable'
```
Report: ✅ No conflicts / ❌ Conflicts detected

### 3. Critical Issues Quick Scan
Scan changed files for:
- `dangerouslySetInnerHTML` without `DOMPurify`
- `any` type usage
- `console.log` left in production code
- `// TODO`, `// FIXME`, `// HACK` comments
- Missing `key` prop in `.map()` renders

### 4. File Summary
List all changed files with line counts (additions/deletions).

### 5. Verdict
| Check | Status |
|-------|--------|
| CI | ✅ / ❌ |
| Conflicts | ✅ / ❌ |
| Critical scan | ✅ / ⚠️ / ❌ |

**Recommendation**: ✅ Ready to merge / ⚠️ Needs attention / ❌ Do not merge
