#!/bin/bash

pacmanInstall=(
    git gh neovim
    android-sdk
    dos2unix jq ripgrep
    python3 python3-pip
    openjdk-8-jdk
    terminator
    gparted
    steam-installer
    nemo
    starship
  )

pacmanRemove=(
    snapd
    flatpak
  )

yayInstall=(
    visual-studio-code-bin
    spotify
    discord
    slack
    scrcpy
    vlc

    nerd-fonts-hack nerd-fonts-noto-sans-mono nerd-fonts-terminus ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
    ttf-ms-fonts ttf-amiri ttf-arabeyes-fonts ttf-qurancomplex-fonts ttf-sil-lateef ttf-sil-scheherazade ttf-google-fonts-git ttf-inconsolata

  )

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes | sudo pacman -Syyu

# Setup and install snap
echo -e "\e[1;34mInstalling pacman packages...\e[0m"
for app in ${pacmanInstall[@]}; do
    echo "Installing $app and requirements..."
    yes | sudo pacman -Sy $app
done

echo -e "\e[1;34mInstalling yay packages...\e[0m"
for app in ${yayInstall[@]}; do
    echo "Installing $app and requirements..."
    yes | yay -Sy $app
done

echo -e "\e[1;34mRemoving preinstalled packages...\e[0m"
for app in ${pacmanRemove[@]}; do
    echo "Installing $app and requirements..."
    yes | sudo pacman -R $app
    if [ "$app" == "snapd" ]; then
      sudo rm -r /var/lib/snapd
    elif [ "$app" == "snap" ]; then
      sudo rm -r /var/lib/flatpak
      rm -r ~/.local/share/flatpak
    fi
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes | sudo pacman -Syyu

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
[ ! -d "$HOME/Programs" ] && mkdir -p $HOME/Programs/lib
[ ! -d "$HOME/Programs" ] && mkdir -p $HOME/Programs/src
[ ! -d "$HOME/Reposetories" ] && mkdir -p $HOME/Reposetories

cd $SCRIPTPATH/ScriptsLinux
cp * $HOME/.bin

cd $SCRIPTPATH/Reposetories
git clone https://github.com/ColdEvul/dotfiles.git
cd dotfiles
chmod +x install
./install

echo -e "done"
