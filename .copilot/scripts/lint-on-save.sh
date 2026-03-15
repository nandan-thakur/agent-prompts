#!/bin/bash
# lint-on-save.sh
# Runs on PostToolUse — auto-lints/formats files after edits

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')

if [ "$TOOL_NAME" = "editFiles" ] || [ "$TOOL_NAME" = "createFile" ]; then
  FILES=$(echo "$INPUT" | jq -r '.tool_input.files[]? // .tool_input.path // empty')
  for FILE in $FILES; do
    if [ -f "$FILE" ]; then
      # Run Prettier on supported files
      if echo "$FILE" | grep -qE '\.(tsx?|jsx?|scss|css|json|md)$'; then
        npx prettier --write "$FILE" 2>/dev/null
      fi
      # Run ESLint auto-fix on JS/TS files
      if echo "$FILE" | grep -qE '\.(tsx?|jsx?)$'; then
        npx eslint --fix "$FILE" 2>/dev/null
      fi
    fi
  done
fi

echo '{"continue":true}'
