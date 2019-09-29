
Write-Host "Starting up..." -ForegroundColor green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser


Write-Host "Installing scoop..." -ForegroundColor green
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

Write-Output "Installing scoop packages..."
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


Write-Host "Installing Chocolately..." -ForegroundColor green
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

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


Write-Host "Downloading drives and programs for gaming..." -ForegroundColor green
Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile/Downloads/TrackIR_5.4.2.exe"
Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.00.42_x86_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.00.42_x86_Logitech.exe"


Write-Host "Installing scoop packages..." -ForegroundColor green

Write-Output "Setting up home..."
New-Item -itemtype "directory" -path "$Env:userprofile\.scripts"
(get-item $Env:userprofile\.scripts).Attributes += 'Hidden'
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.scripts", "User")

New-Item -itemtype "directory" -path "C:\Library"
New-Item -itemtype Junction -path "$Env:userprofile" -name "Library" -value "C:\Library"

Write-Output "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "Home" -value "$Env:userprofile"
New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"
New-Item -itemtype Junction -path "C:\Library\" -name "SteamApps" -value "C:\Program Files\Steam\steamapps"


Write-Output "Setting up shims..."
New-Item -itemtype "directory" -path "C:\ProgramData\Chocolatey\shims"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\shims", "Machine")

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco" -p="C:\ProgramData\Chocolatey\choco.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam.exe" -p="C:\Program Files\Steam\Steam.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam" -p="C:\Program Files\Steam\Steam.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code.exe" -p="$Env:userprofile\AppData\Local\Programs\Microsoft VS Code\Code.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code" -p="$Env:userprofile\AppData\Local\Programs\Microsoft VS Code\Code.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify.exe" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer.exe" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
