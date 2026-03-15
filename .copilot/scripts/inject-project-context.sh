#!/bin/bash
# inject-project-context.sh
# Runs on SessionStart — provides project info to the agent

PROJECT_INFO=$(cat package.json 2>/dev/null | jq -r '"Project: " + .name + " v" + .version' || echo "Project: Unknown")
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
NODE_VER=$(node -v 2>/dev/null || echo "not installed")
UNCOMMITTED=$(git diff --stat HEAD 2>/dev/null | tail -1 || echo "no changes")

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$PROJECT_INFO | Branch: $BRANCH | Node: $NODE_VER | Uncommitted: $UNCOMMITTED"
  }
}
EOF
