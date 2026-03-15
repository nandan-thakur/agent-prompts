# review-cleanup.ps1
# Runs on Stop — cleans up temporary review files

$tempFiles = @(
    "$env:TEMP\review_diff.patch",
    "$env:TEMP\review_diff_frontend.patch",
    "$env:TEMP\review_diff_staged.patch",
    "$env:TEMP\review_diff_branch.patch",
    "$env:TEMP\review_meta.json",
    "$env:TEMP\review_files.txt"
)

foreach ($file in $tempFiles) {
    if (Test-Path $file) { Remove-Item $file -Force }
}

Get-ChildItem "$env:TEMP\review_partial_*.md" -ErrorAction SilentlyContinue | Remove-Item -Force

@{ continue = $true } | ConvertTo-Json
