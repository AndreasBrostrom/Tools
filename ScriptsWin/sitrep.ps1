# Define repository directory
$repoDir = "$HOME/Repositories"

# Initialize variables
$status = @()
$argUpdate = $false
$argCommit = $false
$errorOccurred = $false

# Parse arguments
foreach ($arg in $args) {
    switch ($arg) {
        '--upgrade' { $argUpdate = $true }
        '-u'        { $argUpdate = $true }
        '--pull'    { $argUpdate = $true }
        '-p'        { $argUpdate = $true }
        '--commit'  { $argCommit = $true }
        '-c'        { $argCommit = $true }
        '--push'    { $argCommit = $true }
        '-P'        { $argCommit = $true }
        default {
            Write-Host "Unknown option: $arg" -ForegroundColor Red
            Write-Host "Usage: ./sitrep.ps1 [OPTIONS]" -ForegroundColor Cyan
            Write-Host "  --upgrade, -u, --pull, -p    Update repositories if no changes are found"
            Write-Host "  --commit, -c, --push, -P     Commit and push changes to repositories"
            exit 1
        }
    }
}

if ($Upgrade) {
    $argUpdate = $true
}
if ($Commit) {
    $argCommit = $true
}

Write-Host "Checking dotfile repo status" -ForegroundColor Cyan
if (-not (Test-Path -Path $repoDir)) {
    Write-Host "Repositories directory not found..." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Repo path: $repoDir" -ForegroundColor Gray
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
    "Tools",
    "tools",
    "Scripts",
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
        if ($argCommit) {
            Write-Host "Committing changes in $path" -ForegroundColor Yellow
            git -C $repoPath add --all
            git -C $repoPath commit --all --quiet
            if ($LASTEXITCODE -ne 0) {
                $errorOccurred = $true
                $status += "${path}: Failed to commit changes"
                git -C $repoPath reset --quiet
            } else {
                git -C $repoPath push --quiet
                if ($LASTEXITCODE -ne 0) {
                    $errorOccurred = $true
                    $status += "${path}: Failed to push changes"
                } else {
                    $status += "${path}: Committed and pushed changes"
                }
            }
        } else {
            $status += "${path}: Uncommitted changes"
            $status += $gitStatus
        }
        continue
    }

    # Run updates if no changes are found
    if ($argUpdate) {
        Write-Host "Pulling updates for ${path}" -ForegroundColor Yellow
        $gitPull = git -C $repoPath pull
        if ($gitPull -match "Already up to date") {
            continue
        }
        $gitChanges = git -C $repoPath diff --name-only HEAD@{1}
        if ($gitChanges) {
            $status += "${path}: Repository updated"
            $status += $gitChanges
        } else {
            $status += "${path}: Repository updated, but no file changes detected"
        }
    }
}

# Print sitrep
if ($status.Count -gt 0) {
    Write-Host "`nCurrent status:" -ForegroundColor Cyan
    foreach ($sitrep in $status) {
        Write-Host $sitrep
    }
} else {
    Write-Host "`nCurrent status:" -ForegroundColor Cyan
    Write-Host "All good"
}