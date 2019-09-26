
echo Installing scoop...
iwr -useb get.scoop.sh | iex

echo Installing scoop packages...
scoop install sudo
scoop install aria2 git 7zip go
scoop install sudo --global
scoop install aria2 git 7zip go --global

scoop install curl grep sed less touch ruby perl openssh --global
scoop install ripgrep neovim adb  --global
scoop install python --global

scoop bucket add extras
scoop install steamcmd qbittorrent-portable --global

scoop bucket add Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git
scoop install armake hemtt --global


echo Installing Chocolately...
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

echo Changeing chocolately settings...
choco feature enable -n allowGlobalConfirmation

echo Installing chocolately packages...
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

echo Downloading drives and programs for gaming...
Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile/Downloads/TrackIR_5.4.2.exe"
Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.00.42_x86_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.00.42_x86_Logitech.exe"
