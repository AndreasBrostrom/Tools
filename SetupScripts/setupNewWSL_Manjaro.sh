#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

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
    android-sdk-cmdline-tools-latest
    github-cli
    
    dos2unix jq ripgrep exa xdotool
    python3 python3-pip

    terminator

    gparted gnome-disk-utility
    fish starship

    thunar
    samba manjaro-settings-samba

    node
    ts-node
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

# Setup bashrc and home
echo -e "\e[1;34mSetting up home...\e[0m"

# Setting up home
[ ! -d "$HOME/.bin" ] && mkdir -p $HOME/.bin
[ ! -d "$HOME/Programs" ] && mkdir -p $HOME/Programs
[ ! -d "$HOME/Programs/bin" ] && mkdir -p $HOME/Programs/bin
[ ! -d "$HOME/Programs/lib" ] && mkdir -p $HOME/Programs/lib
[ ! -d "$HOME/Programs/src" ] && mkdir -p $HOME/Programs/src
[ ! -d "$HOME/Repositories" ] && mkdir -p $HOME/Repositories

cd $SCRIPTPATH/ScriptsLinux
cp * $HOME/.bin

cd $SCRIPTPATH/Repositories
git clone https://github.com/AndreasBrostrom/dotfiles.git
cd dotfiles
chmod +x install
./install

python3 $SCRIPTPATH/setupNewWSLHome.py

echo -e "done"
