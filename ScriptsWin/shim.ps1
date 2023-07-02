# Check parameters
param (
    [Parameter(Mandatory=$false)][Switch]$help,
    [Parameter(Mandatory=$false)][Switch]$list,
    [Parameter(Position=1)][String]$target,
    [Parameter(Position=2)][String]$name
)
if ( $help ) {
    Write-Host  "Usage: shim TARGET NAME [-list] [-help]"
    Write-Host  ""
    Write-Host  "    -h, -help          Show this help"
    Write-Host  "    -l, -list          Disable update check for windows"
    exit 0
}

if ( $list ) {
    $shimPaths = "C:\ProgramData\Chocolatey\shims\", "C:\Programs\Bin\"

    Write-Host "Avalible shim paths"
    Write-Host "-------------------"
    foreach  ($shimPath in $shimPaths ) {
        Write-Host "$shimPath"
    }

    Write-Host "`nAvalible shims"
    Write-Host "--------------"
    foreach  ($shimPath in $shimPaths ) {
        Get-ChildItem -Path $shimPath -Name
    }

    Write-Host "  `nNote; all shims are avalible using WSL, powershell and cmd.`n" -ForegroundColor DarkGray
    exit
}

if ( !$target ) { "shim: missing target operand`nTry 'shim -help' for more information."; exit }
if ( !$name ) { "shim: missing name operand`nTry 'shim -help' for more information."; exit }

if ([System.IO.Directory]::Exists("C:\Bin\")) {
        Write-Host "Creating shim" -ForegroundColor White
        shimgen -o "C:\Bin\$name" -p $target >$null 2>&1
        #if ( -not $? ) { Write-Host "Error while creating wsl friendly shim..." -ForegroundColor Red; exit }
        #shimgen -o "C:\Bin\$name.exe" -p $target >$null 2>&1
        if ( -not $? ) { Write-Host "Error while creating exe shim..." -ForegroundColor Red; exit }
        Write-Host "Shims for $target have been created." -ForegroundColor White
} else {
    "shim: can't be created cause shim system have not been setup."; exit
}