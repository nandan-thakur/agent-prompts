---
name: git-diff-fetcher
description: >
  Fetch and filter git diffs for code review. Use when asked to get a PR diff,
  compare local branches, or extract changed frontend files. Works with both
  GitHub PRs (via gh CLI) and local repo changes (via git diff).
---

# Git Diff Fetcher

Fetch, filter, and prepare diffs for code review from either a GitHub PR or local repo changes.

## When to Use
- Before running any code review agent
- When asked to "get the diff" or "show changes"
- When comparing branches or analyzing a PR

---

## Fetching Diffs

### Option A — GitHub PR (PR number or URL provided)

```bash
# Fetch diff for a specific PR
gh pr diff <PR_NUMBER> --patch > /tmp/review_diff.patch

# Fetch PR metadata for context
gh pr view <PR_NUMBER> --json title,body,baseRefName,headRefName,files,additions,deletions \
  > /tmp/review_meta.json

# Quick summary of changed files
gh pr view <PR_NUMBER> --json files --jq '.files[].path'
```

### Option B — Local Repo Changes (no PR provided)

Use `git diff HEAD` to capture all uncommitted + staged changes in the working tree:

```bash
# All uncommitted changes (staged + unstaged) vs HEAD
git diff HEAD > /tmp/review_diff.patch

# Only staged changes
git diff --cached > /tmp/review_diff_staged.patch

# Changes on current branch vs the default base branch
BASE=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@refs/remotes/origin/@@' || echo "main")
git diff origin/${BASE}...HEAD > /tmp/review_diff_branch.patch
```

### Option C — Compare Two Specific Refs

```bash
# Compare any two commits, branches, or tags
git diff <ref1>..<ref2> > /tmp/review_diff.patch

# Compare with a specific number of commits back
git diff HEAD~5..HEAD > /tmp/review_diff.patch
```

---

## Filtering to Frontend Files

From the diff file, extract only frontend-relevant files:

```bash
# Filter to frontend files only
git diff HEAD -- \
  '*.tsx' '*.ts' '*.jsx' '*.js' \
  '*.scss' '*.css' '*.module.scss' '*.module.css' \
  '*.stories.tsx' '*.stories.ts' \
  '*.test.tsx' '*.test.ts' '*.spec.tsx' '*.spec.ts' \
  > /tmp/review_diff_frontend.patch
```

**For PR diffs already saved as a patch file**, filter with grep:
```bash
grep -E '^\+\+\+ b/.*\.(tsx|ts|jsx|js|scss|css|module\.(scss|css))$' /tmp/review_diff.patch \
  | sed 's/^+++ b\///' > /tmp/review_files.txt
```

### Files to Skip
- `node_modules/`, `dist/`, `build/`, `.next/`
- `*.lock`, `*.config.js`, `*.config.ts` (unless relevant)
- Backend files, migrations, CI/CD configs, infra files

---

## Output

Save the filtered diff to `/tmp/review_diff_frontend.patch` and provide:

1. **File list**: All changed frontend files
2. **Stats**: Total files changed, additions, deletions
3. **Categories**: Group by type (components, styles, tests, hooks, utils, store)

The orchestrator or sub-agents can then read `/tmp/review_diff_frontend.patch` for review.
