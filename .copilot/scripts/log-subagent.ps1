# log-subagent.ps1
# Runs on SubagentStart — logs which sub-agent was spawned for audit trail

$input_data = $input | Out-String
$parsed = $input_data | ConvertFrom-Json

$timestamp = if ($parsed.timestamp) { $parsed.timestamp } else { Get-Date -Format "o" }
$sessionId = if ($parsed.sessionId) { $parsed.sessionId } else { "unknown" }
$agentName = if ($parsed.agentName) { $parsed.agentName } else { "unknown" }

$logDir = ".github\hooks"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

Add-Content -Path "$logDir\review-audit.log" -Value "[$timestamp] Session: $sessionId | SubAgent: $agentName"

@{ continue = $true } | ConvertTo-Json
