# Define repository directory
$repoDir = "$HOME/Repositories"
$configFile = "$HOME/.config/sitrep.conf"

# Initialize variables
$status = @()
$argUpdate = $false
$argCommit = $false
$argInstall = $false
$errorOccurred = $false
$hasChanges = $false
$installParams = @()
$installScript = "wdotfiles/install.ps1"

# Create config file if it doesn't exist
if (-not (Test-Path -Path $configFile)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $configFile) | Out-Null
    @"
# Configuration file for sitrep
# Parameters to pass to install scripts

# Example: install_params = ["--wsl", "--no-sudo"]
install_params = []

# Override default install script path (relative to Repositories dir)
# Default: wdotfiles/install.ps1
# install_script = wdotfiles/install.ps1
"@ | Set-Content -Path $configFile
}

# Read config file
if (Test-Path -Path $configFile) {
    $paramsLine = (Get-Content $configFile | Where-Object { $_ -match '^install_params' }) -replace 'install_params\s*=\s*', ''
    if ($paramsLine) {
        $paramsLine = $paramsLine -replace '^\[|\]$', '' -replace '"', '' -replace "'", ''
        if ($paramsLine.Trim()) {
            $installParams = $paramsLine -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        }
    }
    $scriptLine = (Get-Content $configFile | Where-Object { $_ -match '^install_script' }) -replace 'install_script\s*=\s*', ''
    if ($scriptLine -and $scriptLine.Trim()) {
        $installScript = $scriptLine.Trim()
    }
}

function Show-Help {
    Write-Host "Usage: sitrep [OPTIONS]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  --upgrade, -u, --pull, -p    Update repositories if no changes are found"
    Write-Host "  --commit, -c, --push, -P     Commit and push changes to repositories"
    Write-Host "  --install, -i                Run install script for dotfiles (always installs unless combined with --pull, then only on changes)"
    Write-Host "  -ui                          Shorthand for --upgrade --install"
    Write-Host "  --help, -h                   Show this help message"
}

# Parse arguments
foreach ($arg in $args) {
    switch ($arg) {
        '--upgrade' { $argUpdate = $true }
        '-u' { $argUpdate = $true }
        '--pull' { $argUpdate = $true }
        '-p' { $argUpdate = $true }
        '--commit' { $argCommit = $true }
        '-c' { $argCommit = $true }
        '--push' { $argCommit = $true }
        '-P' { $argCommit = $true }
        '--install' { $argInstall = $true }
        '-i' { $argInstall = $true }
        '-ui' { $argUpdate = $true; $argInstall = $true }
        '--help' { Show-Help; exit 0 }
        '-h' { Show-Help; exit 0 }
        default {
            Write-Host "Error: Unknown argument '$arg'" -ForegroundColor Red
            Write-Host ""
            Write-Host "Use --help or -h for usage information"
            exit 1
        }
    }
}

Write-Host "Checking dotfile repo status" -ForegroundColor Cyan
if (-not (Test-Path -Path $repoDir)) {
    Write-Host "Repositories directory not found..." -ForegroundColor Red
    exit 1
}
else {
    $uriLink = "`e]8;;file:///$repoDir`a$repoDir`e]8;;`a"
    Write-Host "Repo path: $uriLink" -ForegroundColor Gray
}

if ($argUpdate) {
    Write-Host "Updating repositories if no changes are found" -ForegroundColor Gray
}

# Define repositories
$dotfiles = @(
    "dotfiles",
    "dotfiles_private",
    "wdotfiles",
    "secure",
    "tools",
    "scripts",
    "win-upgrade"
)

# Process each repository
foreach ($path in $dotfiles) {
    $repoPath = Join-Path -Path $repoDir -ChildPath $path
    if (-not (Test-Path -Path $repoPath)) {
        continue
    }

    # Check for changes
    $gitStatus = git -C $repoPath status --porcelain
    if ($gitStatus) {
        $hasChanges = $true
        if ($argCommit) {
            git -C $repoPath add --all
            git -C $repoPath commit --all --quiet
            if ($LASTEXITCODE -ne 0) {
                $errorOccurred = $true
                $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
                $status += "${uriLink}: `e[31mFailed to commit changes`e[0m"
                git -C $repoPath reset --quiet
            }
            else {
                git -C $repoPath push --quiet
                if ($LASTEXITCODE -ne 0) {
                    $errorOccurred = $true
                    $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
                    $status += "${uriLink}: `e[31mFailed to push changes`e[0m"
                }
                else {
                    $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
                    $status += "${uriLink}: Committed and pushed changes"
                }
            }
            $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
            $status += "`e[2m$gitStatus`e[0m"
        }
        else {
            $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
            $status += "${uriLink}: Uncommitted changes"
            $status += "`e[2m$gitStatus`e[0m"
        }
        continue
    }

    # Run updates if no changes are found
    if ($argUpdate) {
        Write-Host "Pulling updates for ${path}..." -ForegroundColor Gray
        $gitPull = git -C $repoPath pull
        if ($gitPull -match "Already up to date") {
            continue
        }
        $hasChanges = $true
        $gitChanges = git -C $repoPath diff --name-only "HEAD@{1}"
        $uriLink = "`e]8;;file:///$repoPath`a$path`e]8;;`a"
        $status += "${uriLink}: Repository updated"
        $status += "`e[2m$gitChanges`e[0m"
    }
}

# Run install if flag is set
if ($argInstall -and (!$argUpdate -or $hasChanges)) {
    $installScriptPath = Join-Path -Path $repoDir -ChildPath $installScript
    if (Test-Path -Path $installScriptPath) {
        & $installScriptPath @installParams
    }
}

# Print sitrep
if ($status.Count -gt 0) {
    Write-Host "`nCurrent status:" -ForegroundColor Cyan
    foreach ($sitrep in $status) {
        Write-Host $sitrep
    }
}
else {
    Write-Host "`nCurrent status:" -ForegroundColor Cyan
    Write-Host "All good"
}
