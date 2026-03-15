# lint-on-save.ps1
# Runs on PostToolUse — auto-lints/formats files after edits

$input_data = $input | Out-String
$parsed = $input_data | ConvertFrom-Json

if ($parsed.tool_name -eq "editFiles" -or $parsed.tool_name -eq "createFile") {
    $files = @()
    if ($parsed.tool_input.files) { $files = $parsed.tool_input.files }
    elseif ($parsed.tool_input.path) { $files = @($parsed.tool_input.path) }

    foreach ($file in $files) {
        if (Test-Path $file) {
            if ($file -match '\.(tsx?|jsx?|scss|css|json|md)$') {
                npx prettier --write $file 2>$null
            }
            if ($file -match '\.(tsx?|jsx?)$') {
                npx eslint --fix $file 2>$null
            }
        }
    }
}

@{ continue = $true } | ConvertTo-Json
