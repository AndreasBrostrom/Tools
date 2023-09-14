#!/bin/bash
sudo -v

pacmanInstall=(
  git base-devel
  neovim
  
  xorg-server
  pulseaudio
)

yayInstall=(
  android-sdk-cmdline-tools-latest #android-studio
  github-cli
  
  xdotool
  brightnessctl
  
  dos2unix jq ripgrep
  
  python3 python3-pip
  
  terminator
  fish starship
  
  gparted gnome-disk-utility
  
  samba
  
  etcher-bin  # Flashdrive maker
  peek        # Gif recorder
  scrot       # Screenshot captrure
  
  visual-studio-code-bin
  node ts-node
  jdk8-openjdk
  
  google-chrome
  spotify
  discord
  scrcpy
  obs-studio

  vlc
  barrier
  
  all-repository-fonts
  ttf-ms-fonts
)

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes "" | sudo pacman -Syyu
yes "" | yay -Syyu

# Install pacman packages
if [ ${#pacmanInstall[@]} -eq 0 ]; then
  echo -e "\e[1;34mInstalling pacman packages...\e[0m"
  for app in ${pacmanInstall[@]}; do
      echo "Installing $app and requirements..."
      yes "" | sudo pacman -Sy $app
  done
fi

# Install yay
cd /opt
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

# Install yay packages
if [ ${#yayInstall[@]} -eq 0 ]; then
  echo -e "\e[1;34mInstalling yay packages...\e[0m"
  for app in ${yayInstall[@]}; do
      echo "Installing $app and requirements..."
      yes "" | yay -Sy $app
  done
fi

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes "" | sudo pacman -Syyu
yes "" | yay -Syyu


echo -e "\e[1;34mUpdating Font Repository...\e[0m"
fc-cache -rfv

echo -e "\e[1;34mSetting up home...\e[0m"

# Android sdk
if [ -d "$HOME/android-sdk" ]; then 
    echo -e "\e[1;34mFixing android SDK...\e[0m"
    mkdir -p $HOME/.android 1>/dev/null 2>&1
    mv $HOME/android-sdk $HOME/.android/android-sdk 1>/dev/null 2>&1
fi

# Setting up home
mkdir -p $HOME/.ssh
mkdir -p $HOME/Programs/bin
mkdir -p $HOME/Programs/opt
mkdir -p $HOME/Programs/src
ln -sf $HOME/Programs/bin $HOME/.bin

mkdir -p $HOME/Repositories

# Setting up ssh permissions
echo -e "\033[1mFixing permission for ssh\033[0m"
chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/config
chmod 600 $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/*id_rsa
chmod 644 $HOME/.ssh/*.pub

cd $HOME/Repositories
git clone git@github.com:AndreasBrostrom/dotfiles.git
cd $HOME/Repositories/dotfiles
chmod +x install
./install

sudo --reset-timestamp
echo -e "done"
