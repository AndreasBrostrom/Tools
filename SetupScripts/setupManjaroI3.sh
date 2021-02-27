#!/bin/bash

pacmanInstall=(
    git gh neovim
    android-sdk
    snapd
    dos2unix jq ripgrep
    python3 python3-pip
    openjdk-8-jdk
    terminator
    gparted
    steam-installer
    nemo
  )

yayInstall=(
    visual-studio-code-bin
    spotify
    discord
    slack
    scrcpy
    vlc
  )

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
sudo pacman -Syu

# Setup and install snap
echo -e "\e[1;34mInstalling linux apt packages...\e[0m"
for app in ${pacmanInstall[@]}; do
    echo "Installing $app and requirements..."
    sudo pacman -Sy $app
done


echo -e "\e[1;34mInstalling yay packages...\e[0m"
for app in ${yayInstall[@]}; do
    yay -Sy $app
done


echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
sudo pacman -Syyu

echo -e "\e[1;34mSetting up home...\e[0m"

[ ! -f "$HOME/.hidden" ] && touch $HOME/.hidden

# Android sdk
if [ -d "$HOME/android-sdk" ]; then 
    echo -e "\e[1;34mFixing android SDK...\e[0m"
    mkdir $HOME/.android 1>/dev/null 2>&1
    mv $HOME/android-sdk $HOME/.android/android-sdk 1>/dev/null 2>&1
fi

# Setting up home
[ ! -d "$HOME/.bin" ] && mkdir -p $HOME/.bin
[ ! -d "$HOME/Programs" ] && mkdir -p $HOME/Programs/bin

cp $SCRIPTPATH/../MyLibrary/Linux/bash/.bash_aliases $HOME/.
cp $SCRIPTPATH/../MyLibrary/Linux/bash/.bash_path $HOME/.
cp $SCRIPTPATH/../MyLibrary/Linux/bash/.bash_prompt $HOME/.
cp $SCRIPTPATH/../MyLibrary/Linux/bash/.bashrc $HOME/.
cp $SCRIPTPATH/../MyLibrary/Linux/bash/.profile $HOME/.

cp $SCRIPTPATH/../Scripts/adb-key $HOME/.bin/.
cp $SCRIPTPATH/../Scripts/adb-pull $HOME/.bin/.
cp $SCRIPTPATH/../Scripts/adb-push $HOME/.bin/.
cp $SCRIPTPATH/../Scripts/detach $HOME/.bin/.
cp $SCRIPTPATH/../Scripts/gh-pr $HOME/.bin/.

echo -e "done"
