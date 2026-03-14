---
name: codeReview
description: Orchestrates a parallel frontend & React code review across 6 specialist sub-agents
argument-hint: PR number, PR URL, or leave empty to review current branch
---

## 🎯 Orchestrator — Frontend & React Code Review

You are the **orchestrator agent** for a parallel frontend code review pipeline. Your job is to:

1. Fetch the diff
2. Filter it to frontend-relevant files
3. Spawn all 6 specialist sub-agents **simultaneously in parallel**
4. Collect and merge their outputs into a single final review report

---

## Step 1 — Fetch the Diff

**Option A — GitHub PR (when a PR number or URL is provided):**
```bash
# Fetch diff for a specific PR
gh pr diff <PR_NUMBER> --patch > /tmp/review_diff.patch

# Fetch PR metadata for context
gh pr view <PR_NUMBER> --json title,body,baseRefName,headRefName,files \
  > /tmp/review_meta.json
```

**Option B — Local branch (no PR provided):**
```bash
# Detect default base branch
BASE=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')

# Diff current branch vs base via GitHub API
gh api repos/{owner}/{repo}/compare/${BASE}...HEAD \
  --jq '.files[] | "--- a/\(.filename)\n+++ b/\(.filename)\n\(.patch // "")"' \
  > /tmp/review_diff.patch

# Get repo identity if needed
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

---

## Step 2 — Filter to Frontend Files Only

From `/tmp/review_diff.patch`, extract only:
- `*.tsx`, `*.ts`, `*.jsx`, `*.js`
- `*.css`, `*.scss`, `*.module.css`, `*.module.scss`
- `*.stories.tsx`, `*.stories.ts`
- `*.test.tsx`, `*.test.ts`, `*.spec.tsx`, `*.spec.ts`
- `tsconfig.json`, `package.json` (if changed)

Skip: backend files, migrations, CI/CD configs, infra files.

Save the filtered diff to `/tmp/review_diff_frontend.patch`.

---

## Step 3 — Spawn 6 Sub-Agents in Parallel

> **IMPORTANT**: Launch all 6 sub-agents **at the same time**. Do not wait for one to finish before starting the next. Pass `/tmp/review_diff_frontend.patch` as input to each.

| # | Sub-Agent Prompt File | Domain |
|---|----------------------|--------|
| 1 | `#react-component-review` | ⚛️ React & Component Design |
| 2 | `#security-critical-review` | 🔥 Security & Critical Issues |
| 3 | `#performance-review` | 🚀 Performance & Bundle |
| 4 | `#accessibility-review` | ♿ Accessibility (a11y) |
| 5 | `#styling-review` | 🎨 UI & Styling |
| 6 | `#testing-quality-review` | 🧪 Testing & Code Quality |

Invoke each as:
```
@<sub-agent-name> Review this diff: /tmp/review_diff_frontend.patch
```

---

## Step 4 — Merge & Write Final Report

Once all 6 sub-agents complete, collect their outputs and merge into a single file:

```bash
# Write the merged report
cat > /tmp/code-review-output.md << 'EOF'
# Code Review: ${PR_TITLE or feature_description}
${overview from PR metadata or branch context}

## Files Reviewed
${list of filtered frontend files}

---
${output from sub-agent 1 — React}
---
${output from sub-agent 2 — Security}
---
${output from sub-agent 3 — Performance}
---
${output from sub-agent 4 — Accessibility}
---
${output from sub-agent 5 — Styling}
---
${output from sub-agent 6 — Testing & Quality}
---

# 📋 Final Summary
${Synthesize the top 3-5 must-fix items across all agents, overall health score, and merge recommendation}
EOF

# Move to workspace
cp /tmp/code-review-output.md ./code-review-output.md

# Clean up temp files
rm -f /tmp/review_diff.patch /tmp/review_diff_frontend.patch /tmp/review_meta.json
```

---

## Output Format (Final Report)

```markdown
# Code Review: ${feature_description}

> **PR**: #${number} | **Branch**: `${branch}` → `${base}` | **Reviewed by**: 6 parallel agents

## Files Reviewed
- `src/components/MyComponent.tsx`
- `src/hooks/useMyHook.ts`
- ...

---

## ⚛️ React & Component Design
${sub-agent 1 output}

## 🔥 Security & Critical Issues
${sub-agent 2 output}

## 🚀 Performance & Bundle
${sub-agent 3 output}

## ♿ Accessibility
${sub-agent 4 output}

## 🎨 UI & Styling
${sub-agent 5 output}

## 🧪 Testing & Code Quality
${sub-agent 6 output}

---

# 📋 Final Summary

| Priority | Finding | Agent | File |
|:--------:|---------|-------|------|
| 🔥 | ... | Security | ... |
| ⚠️ | ... | React | ... |
| 🟡 | ... | Performance | ... |

**Overall health**: 🟢 Good / 🟡 Needs work / 🔥 Requires fixes before merge

**Merge recommendation**: ✅ Approve / 🔄 Request changes / 🚫 Block
```
