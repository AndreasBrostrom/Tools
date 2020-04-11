
$target    = $args[0]
$name      = $args[1]

if ( $target -eq "-l" -or $target -eq "--list" ) {
    Write-Host "Avalible shims:" -ForegroundColor White
    Get-ChildItem -Path C:\ProgramData\Chocolatey\shims\ -Name

    Write-Host "  `nNote that all shims are avalible using WSL powershell and cmd.`n"
    exit
}

if ( !$args ) { "shim: missing file operand`nTry 'shim --help' for more information."; exit }
if ( !$name ) { "shim: missing name operand`nTry 'shim --help' for more information."; exit }

if ([System.IO.Directory]::Exists("C:\ProgramData\Chocolatey\shims")) {
    if ($operator -eq "--help" ) {
        "Usage: shim TARGET NAME"
        exit
    }

        Write-Host "Creating shim" -ForegroundColor White
        shimgen -o "C:\ProgramData\Chocolatey\shims\$name"     -p "$PWD\$target" >$null 2>&1
        if ( -not $? ) { Write-Host "Error while creating wsl friendly shim..." -ForegroundColor Red; exit }
        shimgen -o "C:\ProgramData\Chocolatey\shims\$name.exe" -p "$PWD\$target" >$null 2>&1
        if ( -not $? ) { Write-Host "Error while creating exe shim..." -ForegroundColor Red; exit }
        Write-Host "Shims for $target have been created." -ForegroundColor White
} else {
    "shim: can't be created cause shim system have not been setup."; exit
}