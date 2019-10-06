#!/usr/bin/env bash

IS_WSL=/mnt/c/WINDOWS/system32/wsl.exe
if [ -x "$IS_WSL" ]; then
    python3 setupNewWSL.py
fi

######################################################
sudo apt update -y
sudo apt full-upgrade -y

sudo apt install git -y
sudo apt install neovim android-sdk dos2unix -y
sudo apt install ninja-build python3 python3-pip -y

sudo apt install steam-installer -y

######################################################
if [ ! -x "$IS_WSL" ]; then
    sudo apt install snapd -y

    sudo snap install ripgrep

    sudo snap install code --classic

    sudo snap install spotify

    sudo snap install discord
    sudo snap install slack --classic
fi

######################################################
echo Adding check for PATH in .bashrc...
echo """

# PATH definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_path, instead of adding them here directly.
if [ -f ~/.bash_path ]; then
    . ~/.bash_path
fi
""" >> ~/.bashrc


######################################################
echo Setting up .scripts... 
mkdir ~/.scripts
echo """#!/usr/bin/env bash 

set -e >> ~/.scripts/adb-push

adb push $1 /sdcard/Download/$2
echo $1: have been pushed to ./sdcard/Download/$2

chmod +x ~/.scripts
""" >> ~/.scripts/adb-push

echo Setting up path... 
echo """
export PATH=\$PATH:~/.scripts

# Android
export ANDROID_HOME=$HOME/android-sdk
export PATH=\$PATH:$ANDROID_HOME/tools/bin
export PATH=\$PATH:$ANDROID_HOME/platform-tools
""" >> ~/.bash_path


######################################################
echo Setting up .bash_aliases... 
echo """ 
alias dir='ls'

alias sys-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh; echo All updates are completed.'

# Python
alias pip='pip3'
alias py='python3'
alias python='python3'

# Sudo
alias inperium='sudo'

# Program
alias vim='nvim'

alias ncspot='~/Library/ncspot/target/release/ncspot'
alias spotify='ncspot'
alias spotify-doc='google-chrome --app=https://github.com/hrkfdn/ncspot/blob/develop/README.md'

alias chrome='google-chrome'
alias screen='echo Running: scrcpy; scrcpy'
alias youtube='chrome --app=https://youtube.com/'

# ADB shorts
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'
alias adb-p='adb-push'

alias rn-android-uninstall='adb-u; rn-a'
alias rn-au='rn-android-uninstall'

# Git shortcuts
alias g-r='git rebase'
alias g-f='git fetch --all --prune'

alias g-fr='git fetch --all --prune; git rebase'
alias g-rf='g-fr'

alias g-s='git status'
alias g-c='git checkout'
alias g-u='git rebase master'

alias g-p='git stash'
alias g-pp='git stash pop'

alias g-frp='g-p; g-rf'
alias g-rfp='g-frp'
alias g-frpp='g-frp; g-pp' 
alias g-rfpp='g-rfpp'
""" >> ~/.bash_aliases
