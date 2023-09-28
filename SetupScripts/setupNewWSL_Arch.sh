#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

pacmanInstall=(
    neovim openssh
  )

yayInstall=(
    android-sdk-cmdline-tools-latest
    github-cli
    
    helix

    xdotool
    brightnessctl
    
    dos2unix jq ripgrep
    exa # ls like tool
    
    terminator
    
    fish starship
    
    thunar
    samba
    
    node ts-node
    jdk8-openjdk
  )


# Setup and install packman
echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes "" | sudo pacman -Syyu

# Installing yay
echo -e "\e[1;34mInstalling yay...\e[0m"
mkdir -p $HOME/Programs/src
cd $HOME/Programs/src
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd $HOME


# Setup and install yay
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
mkdir -p $HOME/.ssh
mkdir -p $HOME/Programs
mkdir -p $HOME/Programs/bin
mkdir -p $HOME/Programs/opt
mkdir -p $HOME/Programs/src
mkdir -p $HOME/Repositories
ln -sf $HOME/Programs/bin $HOME/.bin

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

python3 <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupNewWSLHomeEnv.py)

echo -e "done"
