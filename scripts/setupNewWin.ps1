#Requires -RunAsAdministrator

Write-Host "Starting up..." -ForegroundColor green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# Installing scoop
if (![System.IO.File]::Exists("$env:USERPROFILE\scoop\shims\scoop")) {
    Write-Host "Installing Scoop..." -ForegroundColor green
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} else { Write-Host "Scoop already exist..." -ForegroundColor Yellow }

Write-Output "Installing Scoop packages..."
scoop install aria2 git 7zip
scoop install sudo
scoop install sudo --global
scoop install aria2 git 7zip --global

scoop install curl grep ripgrep sed touch openssh --global
scoop install neovim gdrive jq dos2unix scrcpy --global
scoop install python ruby msys2 perl ninja rust --global

scoop bucket add extras
scoop install steamcmd qbittorrent-portable android-sdk rufus --global

scoop bucket add Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git
scoop install armake hemtt --global

Write-Host "Installation of scoop packages completed..." -ForegroundColor blue


# Installing chocolately
if (![System.IO.File]::Exists("C:\ProgramData\chocolatey\choco.exe")) {
    Write-Host "Installing Chocolately..." -ForegroundColor green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else { Write-Host "Chocolately already exist..." -ForegroundColor Yellow }

Write-Output "Changeing and setting some paths for chocolately..."
choco feature enable -n allowGlobalConfirmation
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")

Write-Output "Installing chocolately packages..."
choco install googlechrome
choco install vscode

choco install microsoft-windows-terminal

choco install winrar
choco install vlc
choco install spotify
choco install teamviewer
choco install TortoiseGit

choco install teamspeak
choco install discord
choco install slack

choco install steam
choco install obs-studio

choco install powershell-core

Write-Host "Installation of chocolately packages completed..." -ForegroundColor blue


# Download drives and packages for gaming
Write-Host "Downloading drives and programs for gaming..." -ForegroundColor green
Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile\Downloads\TrackIR_5.4.2.exe"

Invoke-WebRequest https://media.roccat.org/driver/Tyon/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip -OutFile "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip"
Expand-Archive "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" -DestinationPath "$Env:userprofile\Downloads\"
Remove-Item "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip"

Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.02.65_x64_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.02.65_x64_Logitech.exe"

Write-Host "Drives packages downloaded and ready..." -ForegroundColor blue


# Setting up home enviroment
Write-Output "Setting up home..."

New-Item -itemtype "directory" -path "$Env:userprofile\.scripts"
(get-item $Env:userprofile\.scripts).Attributes += 'Hidden'
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.scripts", "User")

New-Item -itemtype "directory" -path "C:\Programs"
New-Item -itemtype Junction -path "$Env:userprofile" -name "Library" -value "C:\Programs"

New-Item -itemtype "directory" -path "C:\Programs\Bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Programs\Bin", "Machine")

Write-Output "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"

New-Item -itemtype "directory" -path "C:\Program Files (x86)\Steam\steamapps\common"
New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Program Files (x86)\Steam\steamapps\common"


# Setup cmd
Write-Output "Configurating CMD..."
Expand-Archive "$PSScriptRoot\..\WindowsBatchRC\batchrc.zip" -DestinationPath "$Env:userprofile"
reg import "$PSScriptRoot\..\WindowsBatchRC\add_batchrc.reg"


# Setup powershell profile
Write-Output "Configurating Powershell..."

New-Item -itemtype "directory" -path "$Env:userprofile\Documents\PowerShell\"
(get-item $Env:userprofile\Documents\PowerShell).Attributes += 'Hidden'
New-Item -itemtype "directory" -path "$Env:userprofile\Documents\WindowsPowerShell\"
(get-item $Env:userprofile\Documents\WindowsPowerShell).Attributes += 'Hidden'

if ([System.IO.File]::Exists("$PSScriptRoot\..\Library\PowershellProfile\profile.ps1")) {
    Write-Output "Profile restored..."
    Copy-Item "$PSScriptRoot\..\Library\PowershellProfile\profile.ps1" -Destination "$Env:userprofile\Documents\PowerShell\"
} else {
    Write-Output "Creating empty profile..."
    New-Item -itemtype "file" -path "$Env:userprofile\Documents\PowerShell\profile.ps1"
}
New-Item -itemtype SymbolicLink -path "$Env:userprofile" -name ".psrc" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
New-Item -itemtype SymbolicLink -path "$Env:userprofile\Documents\WindowsPowerShell" -name "profile.ps1" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
(get-item $Env:userprofile\.psrc).Attributes += 'Hidden'


# Creating quick links for terminal
Write-Output "Setting up shims..."
New-Item -itemtype "directory" -path "C:\ProgramData\Chocolatey\shims"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\shims", "Machine")

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco" -p="C:\ProgramData\Chocolatey\choco.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam.exe" -p="C:\Program Files (x86)\Steam\Steam.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam" -p="C:\Program Files (x86)\Steam\Steam.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code.exe" -p="C:\Program Files\Microsoft VS Code\Code.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code" -p="C:\Program Files\Microsoft VS Code\Code.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify.exe" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer.exe" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"

Write-Output "Adjusting the context menu..."
reg import "$PSScriptRoot\..\VSCode\Elevation_Add.reg"

reg import "$PSScriptRoot\..\CustomNewFileRegFiles\!cleanUnwantedCreateNewFile.reg"
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewCppFile.reg"
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewHppFile.reg"
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewMdFile.reg"
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewPythonFile.reg"
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewSqfFile.reg"

# Terminals
reg import "$PSScriptRoot\..\WindowsTerminal\add_windowsTerminal.reg"
reg import "$PSScriptRoot\..\ContextMenuCMDnPowershell\CMDOnShellHack.reg"
reg import "$PSScriptRoot\..\Powershell6\Add_Powershell6_context.reg"

# Change windows time
reg import "$PSScriptRoot\..\WindowsUTCTime\Make Windows Use UTC Time.reg"

# Remove VLC
reg import "$PSScriptRoot\..\ContextMenuCleaners\remove_VLC.reg"

Write-Host "Script completed." -ForegroundColor green