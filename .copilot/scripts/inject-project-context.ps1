# inject-project-context.ps1
# Runs on SessionStart — provides project info to the agent

$projectInfo = "Project: Unknown"
if (Test-Path "package.json") {
    $pkg = Get-Content "package.json" | ConvertFrom-Json
    $projectInfo = "Project: $($pkg.name) v$($pkg.version)"
}

$branch = try { git branch --show-current 2>$null } catch { "unknown" }
$nodeVer = try { node -v 2>$null } catch { "not installed" }
$uncommitted = try { (git diff --stat HEAD 2>$null | Select-Object -Last 1) } catch { "no changes" }

@{
    hookSpecificOutput = @{
        hookEventName = "SessionStart"
        additionalContext = "$projectInfo | Branch: $branch | Node: $nodeVer | Uncommitted: $uncommitted"
    }
} | ConvertTo-Json -Depth 3
