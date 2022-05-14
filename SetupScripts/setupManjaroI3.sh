#!/bin/bash
sudo -v

pacmanInstall=(
    git neovim
    yay
  )

pacmanRemove=(
    snapd
    flatpak
  )

yayInstall=(
    jdk8-openjdk
    android-sdk-cmdline-tools-latest #android-studio
    github-cli
    
    dos2unix jq ripgrep exa xdotool
    python3 python3-pip

    terminator

    gparted gnome-disk-utility
    fish starship

    nemo
    samba manjaro-settings-samba

    visual-studio-code-bin
    node
    ts-node
    
    google-chrome
    spotify
    discord
    slack
    scrcpy
    obs-studio
    vlc

    steam

    nerd-fonts-hack nerd-fonts-dejavu-complete nerd-fonts-noto-sans-mono nerd-fonts-terminus ttf-nerd-fonts-symbols
    ttf-ms-fonts
  )

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes "" | sudo pacman -Syyu
yes "" | yay -Syyu

# Setup and install snap
echo -e "\e[1;34mInstalling pacman packages...\e[0m"
for app in ${pacmanInstall[@]}; do
    echo "Installing $app and requirements..."
    yes "" | sudo pacman -Sy $app
done

echo -e "\e[1;34mInstalling yay packages...\e[0m"
for app in ${yayInstall[@]}; do
    echo "Installing $app and requirements..."
    yes "" | yay -Sy $app
done

echo -e "\e[1;34mRemoving preinstalled packages...\e[0m"
for app in ${pacmanRemove[@]}; do
    echo "Installing $app and requirements..."
    yes "" | sudo pacman -R $app
    if [ "$app" == "snapd" ]; then
      sudo rm -r /var/lib/snapd
    elif [ "$app" == "snap" ]; then
      sudo rm -r /var/lib/flatpak
      rm -r ~/.local/share/flatpak
    fi
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes "" | sudo pacman -Syyu
yes "" | yay -Syyu

echo -e "\e[1;34mUpdating Font Repository...\e[0m"
fc-cache -rfv

echo -e "\e[1;34mSetting up home...\e[0m"

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
[ ! -d "$HOME/Repositories" ] && mkdir -p $HOME/Repositories

cd $SCRIPTPATH/ScriptsLinux
cp * $HOME/.bin

cd $HOME/Repositories
git clone git@github.com:AndreasBrostrom/dotfiles.git
cd $HOME/Repositories/dotfiles
chmod +x install
./install

sudo --reset-timestamp
echo -e "done"
