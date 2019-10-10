#Requires -RunAsAdministrator

Write-Host "Starting up..." -ForegroundColor green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

if (![System.IO.File]::Exists("$env:USERPROFILE\scoop\shims\scoop")) {
    Write-Host "Installing Scoop..." -ForegroundColor green
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} else { Write-Host "Scoop already exist..." -ForegroundColor Yellow }

Write-Output "Installing Scoop packages..."
scoop install aria2 git 7zip
scoop install sudo
scoop install sudo --global
scoop install aria2 git 7zip --global

scoop install curl grep ripgrep sed less touch openssh --global
scoop install neovim gdrive jq dos2unix scrcpy --global
scoop install python ruby msys2 perl ninja rust --global

scoop bucket add extras
scoop install steamcmd qbittorrent-portable android-sdk rufus --global

scoop bucket add Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git
scoop install armake hemtt --global


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
choco install steam
choco install winrar
choco install vlc
choco install TortoiseGit
choco install teamspeak
choco install discord
choco install slack
choco install spotify
choco install teamviewer
choco install obs-studio



choco install powershell-core
New-Item -itemtype "file" -path "$Env:userprofile\Documents\PowerShell\profile.ps1"
New-Item -itemtype SymbolicLink -path "$Env:userprofile" -name ".psrc" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
New-Item -itemtype SymbolicLink -path "$Env:userprofile\Documents\WindowsPowerShell" -name "profile.ps1" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
(get-item $Env:userprofile\.psrc).Attributes += 'Hidden'


Write-Host "Downloading drives and programs for gaming..." -ForegroundColor green
Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile/Downloads/TrackIR_5.4.2.exe"

Invoke-WebRequest https://media.roccat.org/driver/Tyon/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip -OutFile "$Env:userprofile/Downloads/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip"
Expand-Archive "$Env:userprofile/Downloads/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" -DestinationPath "$Env:userprofile/Downloads/"
Remove-Item "$Env:userprofile/Downloads/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip"

Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.02.65_x64_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.02.65_x64_Logitech.exe"

Write-Host "Drives packages downloaded and ready..." -ForegroundColor blue


Write-Host "Installing scoop packages..." -ForegroundColor green

Write-Output "Setting up home..."
New-Item -itemtype "directory" -path "$Env:userprofile\.scripts"
(get-item $Env:userprofile\.scripts).Attributes += 'Hidden'
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.scripts", "User")

New-Item -itemtype "directory" -path "C:\Programs"
New-Item -itemtype Junction -path "$Env:userprofile" -name "Library" -value "C:\Programs"

New-Item -itemtype "directory" -path "C:\Programs\Bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Programs\Bin", "Machine")

Write-Output "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "Home" -value "$Env:userprofile"
New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"

New-Item -itemtype "directory" -path "C:\Program Files (x86)\Steam\steamapps\common"
New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Program Files (x86)\Steam\steamapps\common"


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

Write-Host "Script completed." -ForegroundColor green