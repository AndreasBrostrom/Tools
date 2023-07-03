if ( -not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.MyCommand.Name)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline

    # check if have sudo programs installed
    $sudoScripts =  "$env:USERPROFILE\scoop\shims\sudo",
                    "$env:USERPROFILE\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\scoop\shims\sudo",
                    "$env:PROGRAMDATA\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                    "$env:USERPROFILE\.bin\sudo.ps1"

    foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
    if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
    
    Write-Host ", and then running the script again." -ForegroundColor Red
    exit 1
}
if ( -Not $IsWindows ) { Write-host "This script does not work on none-windows system" -ForegroundColor Red; exit 1 }

#Arguments
$targetFile      = $args[0]
$programName     = $args[1]
$optionalName    = $args[2]

if ( $targetFile )  { Write-Host "Missing or invalid argument" -ForegroundColor Red; exit 1 }
if ( $programName ) { Write-Host "Missing or invalid argument" -ForegroundColor Red; exit 1 }

# Constants
$executableDir       = "C:\Bin"
$installationDir     = "C:\Programs\Opt"
$programDir          = Join-Path $installationDir $programName
$latestDir           = Join-Path $installationDir $programName "latest"
$targetFileFullPath  = Get-Item -LiteralPath $targetFile



# Unzip or copy directory to Opt
New-Item -ItemType Directory -Path $programDir
# TODO Add a check for exist already and give happy info
if ((Get-Item $targetFileFullPath) -is [System.IO.DirectoryInfo]){
    Copy-Item -Path $targetFileFullPath -Destination $programDir -Recurse
    if ( $args[2] ) {
        $folder = Get-ChildItem $programDir | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
        Rename-Item -Path $folder -NewName $args[2]
    }
} elseIf ((Get-Item $targetFileFullPath) -is [System.IO.FileInfo]) {
    if ((Get-ChildItem $targetFileFullPath).Extension -eq '.zip') {
        Expand-Archive -Path $targetFileFullPath -DestinationPath $programDir
        if ( $args[2] ) {
            $folder = Get-ChildItem $programDir | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
            Rename-Item -Path $folder -NewName $args[2]
        }
    } else {
        Write-host "$((Get-ChildItem $targetFileFullPath).Extension) is a unsupported file extension" -ForegroundColor Red; exit 1
    }
} else {
    Write-host "Unsupported file or directory" -ForegroundColor Red; exit 1
}



# Update latest
$LatestCreated = Get-ChildItem $programDir | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
New-Item -itemtype Junction -path $installationDir -name "latest" -value $LatestCreated -Force >$null 2>&1



# Make shims out of exe
$executables = Get-ChildItem $latestDir -Filter "*.exe"
foreach ($target in $executables) {
    $dest = Join-Path $executableDir $target.name
    if (Test-Path -Path $dest -PathType Leaf) { Remove-Item $dest }
    shimgen -p $target -o $dest >$null 2>&1
    Write-host "Shim created: $target -> $dest" -ForegroundColor white
}
