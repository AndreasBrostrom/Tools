#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Update apt dist
sudo apt update -y
sudo apt full-upgrade -y

sudo apt install git -y
sudo apt install neovim android-sdk dos2unix jq ripgrep -y

sudo apt install cargo ninja-build -p
sudo apt install python3 python3-pip -y
sudo apt install openjdk-8-jdk -y

# Setup and install snap
if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
    sudo apt-get install gparted -y

    # install I3
    sudo apt install i3-wm
    sudo apt install i3status
    sudo apt install suckless-tools

    sudo apt install steam-installer -y

    sudo add-apt-repository ppa:gnome-terminator -y
    sudo apt update -y
    sudo apt install terminator -y
    
    # snap
    sudo apt install snapd -y

    sudo snap install code --classic

    sudo snap install powershell --classic

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

# Setup Android SDK location
mkdir ~/.android
mv ~/android-sdk ~/.android/android-sdk

# Setup bashrc and home
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bashrc" ~/.bashrc
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_path" ~/.bash_path
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_aliases" ~/.bash_aliases
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.profile" ~/.profile
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_prompt" ~/.bash_prompt

# Nemo
mkdir -p ~/.local/share/nemo/actions/
cp "$SCRIPTPATH/../MyLibrary/Unix/nemo/code.nemo_action" ~/.local/share/nemo/actions/code.nemo_action
cp "$SCRIPTPATH/../MyLibrary/Unix/nemo/sort_actions.sh" ~/.local/share/nemo/actions/sort_actions.sh

# Templates
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/Bash script file.sh" "~/Templates/Bash script file.sh"
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/Python script file.py" "~/Templates/Python script file.py"
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/SQF script file.sqf" "~/Templates/SQF script file.sqf"
cp -r "$SCRIPTPATH/../MyLibrary/Unix/.config" "~/."

# Setup some scripts
mkdir ~/.scripts
cp "$SCRIPTPATH/../Scripts/adb-key" ~/.bin/adb-key
cp "$SCRIPTPATH/../Scripts/adb-push" ~/.bin/adb-push
