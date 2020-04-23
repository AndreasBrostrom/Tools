
# Check parameters
param (
    [Parameter(Mandatory=$false)][Switch]$help,
    [Parameter(Mandatory=$false)][Switch]$Windows,
    [Parameter(Mandatory=$false)][Switch]$Linux,
    [Parameter(Mandatory=$false)][Switch]$Scoop,
    [Parameter(Mandatory=$false)][Switch]$Chocolatey
)
if ($help) {
    Write-Host  "Usage: upgrade [-w] [-l] [-s] [-c] [-help]"
    Write-Host  ""
    Write-Host  "    -h, -help          Show this help"
    Write-Host  "    -w, -windows       Disable update check for windows"
    Write-Host  "    -l, -linux         Disable update check for linux subsystem"
    Write-Host  "    -s, -scoop         Disable update check for Scoop"
    Write-Host  "    -c, -chocolatey    Disable update check for Chocolatey"
    exit 0
}

if ( ![bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.MyCommand.Name)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline
    
    $sudoScripts =  "$env:USERPROFILE\scoop\shims\sudo",
                    "$env:USERPROFILE\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\scoop\shims\sudo",
                    "$env:PROGRAMDATA\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                    "$env:USERPROFILE\.scripts\sudo.ps1"

    foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
    if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
    
    Write-Host ", and then try running the script again." -ForegroundColor Red
    exit 1
}

# Windows update
function runWindowsUpdate {
    Write-Host "This can take some time stand by..." -ForegroundColor DarkGray

    Write-Host "Checking for updates..."
    Get-WindowsUpdate
    Write-Host "Installing updates..."
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -Install 

    Write-Host "Windows update compleat...`n" -ForegroundColor Green
}
if ( -Not $Windows -And [bool](Get-Package -Name PSWindowsUpdate) ) {
    Write-Host "Checking for windows updates..." -ForegroundColor Blue
    runWindowsUpdate
}


# WSL Update
function runWSLUpdate {
    Write-Host "Windows Subsystem for Linux detected..." -ForegroundColor Blue
    
    bash.exe -c "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh;";
    
    Write-Host "Windows Subsystem for Linux update compleat...`n" -ForegroundColor Green
}
if ( -Not $Linux -And [bool](Test-Path "$env:WINDIR\system32\bash.exe" -PathType Leaf) ) {
    runWSLUpdate
}

# Scoop update
function runScoopUpdate {
    Write-Host "Updating Scoop repositories..."
    scoop update

    Write-Host "Updating local packages..."
    scoop update *

    Write-Host "Updating globla packages..."
    scoop update * --global

    Write-Host "Scoop update compleat...`n" -ForegroundColor Green
}
if ( -Not $Scoop -And [bool](Test-Path "$env:USERPROFILE\scoop\shims\scoop" -PathType Leaf) ) {
    Write-Host "Scoop detected..." -ForegroundColor Blue
    runScoopUpdate
}

# Chocolatey Update
function runChocolateyUpdate {
    Write-Host "Updating packages..." -ForegroundColor Blue

    choco upgrade all -y

    Write-Host "Chocolatey update compleat...`n" -ForegroundColor Green
}
if ( -Not $Chocolatey -And [bool](Test-Path "$env:ChocolateyInstall\choco.exe" -PathType Leaf) ) {
    Write-Host "Chocolatey detected..." -ForegroundColor Blue
    runChocolateyUpdate

    # Cleaning up of unwhanted desktop icons
    Write-Host "Cleaning up Chocolatey created desktop icons...`n"
    function RemoveShortcut-Item($ShortcutName) {
        Remove-Item -Path "$env:USERPROFILE\Desktop\$ShortcutName" >$null 2>&1
        Remove-Item -Path "C:\Users\Default\Desktop\$ShortcutName" >$null 2>&1
        Remove-Item -Path "C:\Users\Public\Desktop\$ShortcutName" >$null 2>&1
    }
    RemoveShortcut-Item "Spotify.lnk"
    RemoveShortcut-Item "WindowsTerminal.lnk"
    RemoveShortcut-Item "OBS Studio.lnk"
    RemoveShortcut-Item "TeamSpeak 3 Client.lnk"
    RemoveShortcut-Item "Discord.lnk"
    RemoveShortcut-Item "Visual Studio Code.lnk"
}

Write-Host "All updates is completed." -ForegroundColor Green
