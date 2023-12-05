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
  android-sdk-cmdline-tools-latest #android-studio
  github-cli

  helix
  
  xdotool
  brightnessctl


  dos2unix jq ripgrep
  exa # ls like tool
  
  python3 python3-pip
  
  terminator
  
  gparted gnome-disk-utility
  fish starship
  
  samba manjaro-settings-samba
  
  etcher-bin  # Flashdrive maker
  peek        # gif recorder
  
  visual-studio-code-bin
  node ts-node
  jdk8-openjdk
  
  google-chrome
  spotify
  discord
  scrcpy
  obs-studio webcamoid
  vlc
  barrier
  
  steam
  
  all-repository-fonts
  nerd-fonts-noto-sans-mono-extended
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


echo -e "\e[1;34mSetting up pulseaudio...\e[0m"
install_pulse


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
mkdir -p $HOME/Programs/bin
mkdir -p $HOME/Programs/opt
mkdir -p $HOME/Programs/src
ln -sf $HOME/Programs/bin $HOME/.bin

mkdir -p $HOME/Pictures/Background

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
