#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

pacmanInstall=(
    neovim openssh
  )

yayInstall=(
    jdk8-openjdk
    android-sdk-cmdline-tools-latest
    github-cli
    
    dos2unix jq ripgrep exa xdotool
    python3 python3-pip

    terminator

    fish starship

    thunar
    samba

    node
    ts-node
  )

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes "" | sudo pacman -Syyu

echo -e "\e[1;34mInstalling yay...\e[0m"
mkdir -p $HOME/Programs/src
cd $HOME/Programs/src
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd $HOME


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

echo -e " \033[2mFixing SSH permissions\033[0m"
chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/config
chmod 600 $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/*id_rsa
chmod 644 $HOME/.ssh/*.pub

cd $HOME/Repositories
git clone git@github.com:AndreasBrostrom/Tools.git
git clone git@github.com:AndreasBrostrom/dotfiles.git
cd dotfiles
chmod +x install
./install

python3 $HOME/Repositories/Tools/SetupScripts/setupNewWSLHome.py

echo -e "done"
