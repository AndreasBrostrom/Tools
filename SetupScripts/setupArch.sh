#!/bin/bash
sudo -v

pacmanInstall=(
  git
  base-devel
  openssh
  man-db
)

paruInstall=(
  # Theme and appearance 
  wol                 # WakeOnLan
  numlockx            # numlock toggler

  # Tools
  tldr      # tldr #  man TLDR
  bat       # cat
  eza       # Modern ls (exa)

  pacman-contrib  # paccache # clear cashe

  xclip         # clipboard
  xdotool
  brightnessctl

  # Settings and system
  gparted                                 # Disk partition tool
  gnome-disk-utility dosfstools ntfsprogs # Disk handling tools and modules
  baobab-gtk3                             # baobab # Disk Usage Analyzer
  dconf-editor d-spy                      # Variable and system browser
  samba                                   # Network

  # Audio
  pavucontrol pa-applet
  
  dos2unix jq ripgrep # Utilities
  github-cli
  android-sdk-cmdline-tools-latest # ADB
  
  # Terminal and shell
  terminator
  starship fish zsh 
  
  # Terminal Utils
  dos2unix jq ripgrep
  github-cli
  android-sdk-cmdline-tools-latest # ADB
   
  thunar # File manager
  gvfs   # Virtual filesystem implementation for GIO
  thunar-archive-plugin thunar-media-tags-plugin thunar-volman thunar-shares-plugin
  file-roller # Archive manager
  
  balena-etcher  # Flashdrive maker
  peek           # Gif recorder
  scrot          # Screenshot capture
  
  # Programs
  visual-studio-code-bin
  neovim helix

  node
  python3
  
  gnome-calculator

  google-chrome

  spotify
  discord
  scrcpy

  obs-studio webcamoid
  vlc
  barrier
  
  gimp
  pinta # Paint-ish
  qview 

  yed # graph editor

  # Fonts
  all-repository-fonts
  nerd-fonts-noto-sans-mono-extended
  ttf-ms-fonts
)

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes "" | sudo pacman -Syyu

# Install pacman packages
echo -e "\e[1;34mInstalling pacman packages...\e[0m"
for app in ${pacmanInstall[@]}; do
    echo "Installing $app and requirements..."
    yes "" | sudo pacman -Sy $app
done

# Install paru packages
echo -e "\e[1;34mInstalling paru packages...\e[0m"
for app in ${paruInstall[@]}; do
    echo "Installing $app and requirements..."
    yes "" | paru -Sy --skipreview --sudoloop $app
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes "" | paru -Syyu --skipreview --sudoloop


echo -e "\e[1;34mUpdating Font Repository...\e[0m"
fc-cache -rfv

echo -e "\e[1;34mSetting up home...\e[0m"

# Android sdk
if [ -d "$HOME/android-sdk" ]; then 
    echo -e "\e[1;34mFixing android SDK...\e[0m"
    mkdir -p $HOME/.android 1>/dev/null 2>&1
    mv $HOME/android-sdk $HOME/.android/android-sdk 1>/dev/null 2>&1
fi

# Setup GT
# gsettings set org.gnome.desktop.interface gtk-theme Adwaita
# gsettings set org.gnome.desktop.interface color-scheme prefer-dark

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

#systemctl services
echo -e "\e[1;34mSetting up systemctl...\e[0m"

sudo systemctl enable --now paccache.timer

# Reset done
sudo --reset-timestamp
echo -e "done"
