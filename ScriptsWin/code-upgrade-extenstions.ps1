# code-upgrade-extensions.ps1

Write-Host "Checking extensions..." -ForegroundColor Cyan

# Get all installed extensions
$allExtensions = code --list-extensions

$extCount = ($allExtensions | Measure-Object).Count
Write-Host "Found extensions: ($extCount)" -ForegroundColor Yellow
foreach ($ext in $allExtensions) {
    Write-Host " -> $ext" -ForegroundColor DarkGray
}

Write-Host "Upgrading extensions" -ForegroundColor Cyan
foreach ($ext in $allExtensions) {
    Write-Host " -> Updating $ext..." -ForegroundColor Yellow
    code --install-extension $ext --force --user-data-dir="$env:TEMP\vscode-update" | Out-Null
}

Write-Host "Done upgrading $extCount vscode extensions." -ForegroundColor Magenta