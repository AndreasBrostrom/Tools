
Write-Host "Starting up..." -ForegroundColor green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

Write-Host "Installing scoop..." -ForegroundColor green
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

Write-Output "Installing scoop packages..."
scoop install aria2 git 7zip
scoop install sudo
scoop install sudo --global
scoop install aria2 git 7zip --global

scoop install curl grep sed less touch ruby perl openssh jq --global
scoop install ripgrep neovim adb dos2unix scrcpy --global
scoop install python rust gdrive --global

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


New-Item -itemtype "directory" -path "$Env:userprofile\.library"
(get-item $Env:userprofile\.library).Attributes += 'Hidden'


New-Item -itemtype "directory" -path "C:\Usr"
New-Item -itemtype "directory" -path "C:\Usr\game"  # Global game installation directory
New-Item -itemtype "directory" -path "C:\Usr\lib"   # Global program installation directory
New-Item -itemtype "directory" -path "C:\Usr\bin"   # Global shims directory made by shimgen
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Usr\bin", "Machine")

New-Item -itemtype Junction -path "C:\Usr" -name "local" -value "$Env:userprofile\scoop\shims"  # Local shims directory made by scoop
New-Item -itemtype Junction -path "C:\Usr" -name "share" -value "C:\ProgramData\scoop\shims"    # Global shims directory made by scoop


Write-Output "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "Home" -value "$Env:userprofile"
New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"

New-Item -itemtype Junction -path "C:\Usr\game" -name "SteamApps" -value "C:\Program Files\Steam\steamapps\"


Write-Output "Setting up shims..."
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\choco" -p="C:\ProgramData\Chocolatey\choco.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\google-chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\google-chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\steam.exe" -p="C:\Program Files\Steam\Steam.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\steam" -p="C:\Program Files\Steam\Steam.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\code.exe" -p="$Env:userprofile\AppData\Local\Programs\Microsoft VS Code\Code.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\code" -p="$Env:userprofile\AppData\Local\Programs\Microsoft VS Code\Code.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\spotify.exe" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\spotify" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe"

C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\TeamViewer.exe" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Usr\bin\TeamViewer" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe"
