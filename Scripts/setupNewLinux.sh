#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Update apt dist
sudo apt update -y
sudo apt full-upgrade -y

sudo apt install git -y
sudo apt install neovim android-sdk dos2unix jq -y

sudo apt install cargo ninja-build -p
sudo apt install python3 python3-pip -y

sudo apt install steam-installer -y

# Setup and install snap
if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
    sudo apt install snapd -y

    sudo snap install ripgrep --classic

    sudo snap install code --classic

    sudo snap install powershell --classic

    sudo snap install spotify

    sudo snap install discord
    sudo snap install slack --classic

    sudo snap install scrcpy
    sudo snap install vlc
fi

# Installing other files
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
sudo dpkg -i ripgrep_11.0.2_amd64.deb
rm ripgrep_11.0.2_amd64.deb

# Setup WSL if exist
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    python3 setupNewWSL.py
fi

# Setup bashrc and home
cp "$SCRIPTPATH/../Library/bashrc/.bashrc" ~/.bashrc
cp "$SCRIPTPATH/../Library/bashrc/.bash_path" ~/.bash_path
cp "$SCRIPTPATH/../Library/bashrc/.bash_aliases" ~/.bash_aliases

# Setup some scripts
mkdir ~/.scripts
cp "$SCRIPTPATH/../Tools/adb-key" ~/.scripts/adb-key
cp "$SCRIPTPATH/../Tools/adb-push" ~/.scripts/adb-push
