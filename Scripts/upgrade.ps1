# Check parameters
param (
    [Parameter(Mandatory=$false)][Switch]$help,
    [Parameter(Mandatory=$false)][Switch]$Windows,
    [Parameter(Mandatory=$false)][Switch]$Linux,
    [Parameter(Mandatory=$false)][Switch]$Scoop,
    [Parameter(Mandatory=$false)][Switch]$Chocolatey,
    [Parameter(Mandatory=$false)][Switch]$Version,
    [Parameter(Mandatory=$false)][Switch]$Upgrade
)
if ($help) {
    Write-Host  "Usage: $((Get-Item $PSCommandPath).Basename) [-w] [-l] [-s] [-c] [-v] [-help]"
    Write-Host  ""
    Write-Host  "    -h, -help          Show this help"
    Write-Host  "    -w, -windows       Disable update check for windows"
    Write-Host  "    -l, -linux         Disable update check for linux subsystem"
    Write-Host  "    -s, -scoop         Disable update check for Scoop"
    Write-Host  "    -c, -chocolatey    Disable update check for Chocolatey"
    Write-Host  "    -v, -version       Show current version"
    exit 0
}
if ($Version) {
    $versionNr = 1,10,0
    $newUpScript = Invoke-WebRequest "https://raw.githubusercontent.com/ColdEvul/Tools/master/Scripts/upgrade.ps1"
    $newUpScriptStr = ($newUpScript.Content).ToString() -split '\n'
    $newUpScriptVer = $newUpScriptStr | Select-String -Pattern 'versionNr'
    $newUpScriptVer = $newUpScriptVer -split "=" -split "," -replace " ", ""

    Write-Host "Version $($versionNr[0]).$($versionNr[1]).$($versionNr[2])"

    $newUpdateVersion = $false
    if ($versionNr[0] -lt $newUpScriptVer[1]) {
        $newUpdateVersion = $true
    }
    if ($versionNr[1] -lt $newUpScriptVer[2]) {
        if ($versionNr[0] -le $newUpScriptVer[1]) {
            $newUpdateVersion = $true
        }
    }
    if ($versionNr[2] -lt $newUpScriptVer[3]) {
        if ($versionNr[1] -le $newUpScriptVer[2]) {
            if ($versionNr[0] -le $newUpScriptVer[1]) {
                $newUpdateVersion = $true
            }
        }
    }

    if ($newUpdateVersion) {
        Write-Host "New version avalible v$($newUpScriptVer[1]).$($newUpScriptVer[2]).$($newUpScriptVer[3])"
        Write-Host "Run `"$((Get-Item $PSCommandPath).Basename) -upgrade`" to update the script."
        exit 0
    }
    exit 0
}
if ($Upgrade) {
    $newUpScript = Invoke-WebRequest "https://raw.githubusercontent.com/ColdEvul/Tools/master/Scripts/upgrade.ps1"
    ($newUpScript.Content).ToString() | Out-File -FilePath (Get-Item $PSCommandPath ).FullName
}

if ( ![bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.MyCommand.Name)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline
    
    $sudoScripts =  "$env:USERPROFILE\scoop\shims\sudo",
                    "$env:USERPROFILE\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\scoop\shims\sudo",
                    "$env:PROGRAMDATA\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                    "$env:USERPROFILE\.bin\sudo.ps1"

    foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
    if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
    
    Write-Host ", and then try running the script again." -ForegroundColor Red
    exit 1
}

# WSL Update
function runWSLUpdate {
    Write-Host "Windows Subsystem for Linux detected..." -ForegroundColor Blue
    
    bash.exe -c "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y";
    
    Write-Host "Windows Subsystem for Linux update compleat...`n" -ForegroundColor Green
}
if ( -Not $Linux -And [bool](Test-Path "$env:WINDIR\system32\bash.exe" -PathType Leaf) ) {
    runWSLUpdate
}

# Windows update
function runWindowsUpdate {
    Write-Host "This can take some time stand by..." -ForegroundColor DarkGray

    Write-Host "Checking for updates..."
    Get-WindowsUpdate
    Write-Host "Installing updates..."
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -Install >$null 2>&1

    Write-Host "Windows update compleat...`n" -ForegroundColor Green
}

if ( -Not $Windows -And [bool](Get-Command -module PSWindowsUpdate) ) {
    if ( -Not [BOOL](Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "DoNotConnectToWindowsUpdateInternetLocations" ) ) {
        Write-Host "Checking for windows updates..." -ForegroundColor Blue
        runWindowsUpdate
    } else {
        Write-Host "Windows update is currently disabled in regestry skipping...`n" -ForegroundColor Yellow
    }
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

    # Get links on desctop befor installation
    $Desktops =    "$env:USERPROFILE\Desktop\$ShortcutName",
                    "C:\Users\Default\Desktop\$ShortcutName",
                    "C:\Users\Public\Desktop\$ShortcutName" 
    $preDesktop = @()
    foreach ($Desktop in $Desktops) {
        $items = Get-ChildItem -Path $Desktop -Name -Include "*.lnk"
        foreach ($item in $items) {
            $preDesktop += $item
        }
    }

    # Update choco
    runChocolateyUpdate

    # Cleaning up new unwhanted desktop icons
    Write-Host "Cleaning up Chocolatey created desktop icons...`n"

    $newDesktopLinks = @()
    foreach ($Desktop in $Desktops) {
        $items = Get-ChildItem -Path $Desktop -Name -Include "*.lnk"
        foreach ($item in $items) {
            if ($preDesktop -contains $item ) {
            } else {
                $newDesktopLinks += $item
            }
        }
    }
    function RemoveShortcut-Item($ShortcutName) {
        Remove-Item -Path "$env:USERPROFILE\Desktop\$ShortcutName" >$null 2>&1
        Remove-Item -Path "C:\Users\Default\Desktop\$ShortcutName" >$null 2>&1
        Remove-Item -Path "C:\Users\Public\Desktop\$ShortcutName" >$null 2>&1
    }
    foreach ($item in $newDesktopLinks) {
        RemoveShortcut-Item $item
        Write-Host "Cleaned up $item" -ForegroundColor DarkGray
    }
}

Write-Host "All updates is completed." -ForegroundColor Green
