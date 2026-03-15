# block-dangerous.ps1
# Runs on PreToolUse — blocks destructive terminal commands

$input_data = $input | Out-String
$parsed = $input_data | ConvertFrom-Json

if ($parsed.tool_name -eq "runTerminalCommand") {
    $command = $parsed.tool_input.command
    if ($command -match '(rm\s+-rf|DROP\s+TABLE|DELETE\s+FROM|git\s+push\s+--force|git\s+reset\s+--hard)') {
        @{
            hookSpecificOutput = @{
                permissionDecision = "deny"
                permissionDecisionReason = "Destructive command blocked by security policy. Use the terminal manually for this operation."
            }
        } | ConvertTo-Json -Depth 3
        exit 0
    }
}

@{ continue = $true } | ConvertTo-Json
