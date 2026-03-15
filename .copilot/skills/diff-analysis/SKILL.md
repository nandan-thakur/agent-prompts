---
name: diff-analysis
description: >
  Parse and filter git diffs for code review. Use this skill when asked to analyze
  a PR diff, compare branches, or extract changed files by type. Works with both
  local git diffs and GitHub PR diffs via the gh CLI.
---

# Diff Analysis Skill

This skill helps you parse, filter, and analyze git diffs for targeted code review.

## When to Use
- When asked to analyze a PR or branch comparison
- When filtering a diff to specific file types (frontend, backend, tests)
- When extracting specific change patterns from a diff

## Fetching Diffs

### From a GitHub PR
```bash
# Get the raw patch diff
gh pr diff <PR_NUMBER> --patch > /tmp/review_diff.patch

# Get PR metadata (title, description, files changed)
gh pr view <PR_NUMBER> --json title,body,baseRefName,headRefName,files,additions,deletions
```

### From Local Branch
```bash
# Detect the default base branch
BASE=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')

# Generate diff against base
git diff ${BASE}...HEAD > /tmp/review_diff.patch

# List only changed files
git diff ${BASE}...HEAD --name-only
```

## Filtering by File Type

### Frontend Files Only
```bash
# Extract only frontend-relevant files from the diff
git diff ${BASE}...HEAD -- \
  '*.tsx' '*.ts' '*.jsx' '*.js' \
  '*.scss' '*.css' '*.module.scss' '*.module.css' \
  '*.test.tsx' '*.test.ts' '*.spec.tsx' '*.spec.ts' \
  '*.stories.tsx' '*.stories.ts'
```

### Exclude Patterns
Skip: `node_modules/`, `dist/`, `build/`, `*.lock`, `*.config.js` (unless relevant)

## Diff Interpretation Guide
- Lines starting with `+` = added
- Lines starting with `-` = removed
- Lines starting with ` ` (space) = unchanged context
- `@@` lines = hunk headers showing line numbers
- `diff --git a/... b/...` = file header

## Output
Provide a structured summary:
1. **Files changed**: List with counts (additions/deletions)
2. **Change categories**: Group by type (components, styles, tests, hooks, utils)
3. **Notable patterns**: Large files, new dependencies, deleted code
