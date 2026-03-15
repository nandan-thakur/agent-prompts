#!/bin/bash
# block-dangerous.sh
# Runs on PreToolUse — blocks destructive terminal commands

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input')

if [ "$TOOL_NAME" = "runTerminalCommand" ]; then
  COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty')

  # Block destructive commands
  if echo "$COMMAND" | grep -qE '(rm\s+-rf|DROP\s+TABLE|DELETE\s+FROM|git\s+push\s+--force|git\s+reset\s+--hard)'; then
    echo '{"hookSpecificOutput":{"permissionDecision":"deny","permissionDecisionReason":"Destructive command blocked by security policy. Use the terminal manually for this operation."}}'
    exit 0
  fi
fi

echo '{"continue":true}'
