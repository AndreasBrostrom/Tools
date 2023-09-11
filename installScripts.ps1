if ( -Not $IsWindows ) {
    Write-host "This script does not work on none-windows system" -ForegroundColor Red
    exit 1
}

$IS_ADMIN = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
$NON_ADMIN_MODE = $false

if ( -not $IS_ADMIN ) {
    Write-Host "Not running as admin will copy files instead of linking them."
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    $NON_ADMIN_MODE = $true
}

# Copy user scripts
$dest = "$($env:USERPROFILE)\.bin"

if ( $IS_ADMIN ) {
    Write-host "Linking scripts to $dest\."
} else {
    Write-host "Copying scripts to $dest\."
}
ForEach ($filePath in Get-ChildItem "ScriptsWin") {
    $path = "$($dest)\$($filePath.name)"
    if ( $IS_ADMIN ) {
        New-Item -ItemType SymbolicLink -Target "$filePath" -Path $path -Force
    } else {
        Copy-Item -Path $filePath -Destination $dest -Force
    }
}

if ($NON_ADMIN_MODE) { exit 0 }

if ( -not $IS_ADMIN ) {
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

$destRoot = "C:\bin"

Write-host "Linking scripts to $destRoot\."
ForEach ($filePath in Get-ChildItem "ScriptsWinExec") {
    $path = "$($destRoot)\$($filePath.name)"
    New-Item -ItemType SymbolicLink -Target "$filePath" -Path $path -Force
}