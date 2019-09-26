
echo Installing scoop...
iwr -useb get.scoop.sh | iex

echo Installing scoop packages...
scoop install sudo
sudo scoop install aria2 git 7zip go
scoop install sudo --global
sudo scoop install aria2 git 7zip go --global

sudo scoop install curl grep sed less touch ruby perl openssh --global
sudo scoop install ripgrep neovim adb  --global
sudo scoop install python --global

scoop bucket add extras
sudo scoop install steamcmd qbittorrent-portable --global

scoop bucket add Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git
sudo scoop install armake hemtt --global


echo Installing Chocolately...
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

echo Changeing chocolately settings...
choco feature enable -n allowGlobalConfirmation

echo Installing chocolately packages...
sudo choco install googlechrome
sudo choco install vscode
sudo choco install microsoft-windows-terminal
sudo choco install steam
sudo choco install winrar
sudo choco install vlc
sudo choco install TortoiseGit
