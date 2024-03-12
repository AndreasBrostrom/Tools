if ( -not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.MyCommand.Name)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline

    # check if have sudo programs installed
    $sudoScripts =  "$Env:USERPROFILE\scoop\shims\sudo",
                    "$Env:USERPROFILE\scoop\shims\sudo.ps1",
                    "$Env:PROGRAMDATA\scoop\shims\sudo",
                    "$Env:PROGRAMDATA\scoop\shims\sudo.ps1",
                    "$Env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                    "$Env:USERPROFILE\.bin\sudo.ps1",
                    "$Env:SCOOP_GLOBAL\shims\sudo",
                    "$Env:SCOOP_GLOBAL\shims\sudo.ps1"

    foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
    if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
    
    Write-Host ", and then running the script again." -ForegroundColor Red
    exit 1
}
if ( -Not $IsWindows ) { Write-host "This script does not work on none-windows system" -ForegroundColor Red; exit 1 }

if ( $args.count -eq 0 ) {
    Write-Host "Usage: install-opt TARGET NAME VERSIONNAME"
    exit 0
}

#Arguments
$targetFile      = $args[0]
$programName     = $args[1]
$versionName     = $args[2]

if ( -not $targetFile  ) { Write-Host "Missing or invalid argument" -ForegroundColor Red; exit 1 }
if ( -not $programName ) { Write-Host "Missing or invalid argument" -ForegroundColor Red; exit 1 }
if ( -not $versionName ) { Write-Host "Missing or invalid argument" -ForegroundColor Red; exit 1 }

if ( -not (Test-Path -Path $targetFile -PathType Leaf) ) { Write-Host "$targetFile does not exist" -ForegroundColor Red; exit 1 }

# Constants
$executableDir       = "C:\Bin"
$installationDir     = "C:\Programs\Opt"
$programDir          = Join-Path $installationDir $programName
$subFolder           = Join-Path $installationDir $programName $versionName
$latestDir           = Join-Path $installationDir $programName "latest"
$targetFileFullPath  = Get-Item -LiteralPath $targetFile

# TODO Test if Version already is installed

# Unzip or copy directory to Opt
Write-host "Installing $programName in to $installationDir..." -ForegroundColor Blue
New-Item -ItemType Directory -Path $subFolder -Force >$null 2>&1

# TODO Add a check for exist already and give happy info
if ((Get-Item -Path $targetFileFullPath) -is [System.IO.DirectoryInfo]){
    Copy-Item -Path $targetFileFullPath -Destination $subFolder -Recurse -Force >$null 2>&1
} elseIf ((Get-Item $targetFileFullPath) -is [System.IO.FileInfo]) {
    if ((Get-ChildItem $targetFileFullPath).Extension -eq '.zip') {
        Expand-Archive -Path $targetFileFullPath -DestinationPath $subFolder >$null 2>&1
        Write-host "Installation successful in: $subFolder" -ForegroundColor white
    } else {
        Write-host "$((Get-ChildItem $targetFileFullPath).Extension) is a unsupported file extension" -ForegroundColor Red; exit 1
    }
} else {
    Write-host "Unsupported file or directory" -ForegroundColor Red; exit 1
}

# Update latest
Write-host "Updating latest junction..." -ForegroundColor White
Remove-Item -Path $latestDir -ErrorAction SilentlyContinue >$null 2>&1
$LatestCreated = Get-ChildItem $programDir | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
New-Item -itemtype Junction -Target $LatestCreated -Path $latestDir -Force >$null 2>&1
if ( Test-Path -Path $latestDir ) {
    Write-Host "Latest junction for $versionName have been created..." -ForegroundColor White
    Write-Host "  $LatestCreated -> $latestDir" -ForegroundColor White
} else {
    Write-Host "latest junction for $versionName could not be created..." -ForegroundColor Red; exit 1
}

# Make shims out of exe
$executables = Get-ChildItem $latestDir -Filter "*.exe"
foreach ($target in $executables) {
    $dest = Join-Path $executableDir $target.name
    if (Test-Path -Path $dest -PathType Leaf) { Remove-Item $dest }
    shimgen -p $target -o $dest >$null 2>&1
    Write-host "Created binary shim..." -ForegroundColor white
    Write-host "  $target -> $dest" -ForegroundColor white
}

Write-host "Installation successfully completed" -ForegroundColor Green