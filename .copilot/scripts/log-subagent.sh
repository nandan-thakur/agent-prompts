#!/bin/bash
# log-subagent.sh
# Runs on SubagentStart — logs which sub-agent was spawned for audit trail

INPUT=$(cat)
TIMESTAMP=$(echo "$INPUT" | jq -r '.timestamp // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.sessionId // empty')
AGENT_NAME=$(echo "$INPUT" | jq -r '.agentName // "unknown"')

LOG_DIR=".github/hooks"
mkdir -p "$LOG_DIR"

echo "[$TIMESTAMP] Session: $SESSION_ID | SubAgent: $AGENT_NAME" >> "$LOG_DIR/review-audit.log"

echo '{"continue":true}'
