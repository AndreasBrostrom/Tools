#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Update apt dist
sudo apt update -y
sudo apt full-upgrade -y

sudo apt install git -y
sudo apt install neovim android-sdk dos2unix -y
sudo apt install ninja-build python3 python3-pip -y

sudo apt install steam-installer -y

# Setup and install snap
if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
    sudo apt install snapd -y

    sudo snap install ripgrep --classic

    sudo snap install code --classic

    sudo snap install spotify

    sudo snap install discord
    sudo snap install slack --classic

    sudo snap install scrcpy
    sudo snap install vlc
fi

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
