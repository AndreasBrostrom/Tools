#!/bin/bash
sudo -v

pacmanInstall=(
  git
  base-devel
  openssh
  man-db
)

paruInstall=(
  samba

  # Theme and apparaence 
  gtk4 
  lxappearance-gtk3
  lxsession-gtk3 # gui auth
  picom polkit
  lightdm-webkit2-greeter
  wol # WakeOnLan
  numlockx # numlock toggler
  conky notification-daemon
  feh # (background)

  # Tools
  trld
  bat # cat
  eza # modern ls (exa)

  pacman-contrib # paccache to clear cashe

  xclip # clipboard
  xdotool
  brightnessctl

  # Settigns and system stuff
  gparted gnome-disk-utility
  baobab-gtk3 # Disk Usage Analyzer
  dosfstools ntfsprogs # gnome disks moduels
  dconf-editor d-feet
  samba # Network

  # Audio
  pavucontrol pa-applet
  
  dos2unix jq ripgrep # Utilities
  github-cli
  android-sdk-cmdline-tools-latest # ADB
  
  terminator, starship, fish, zsh # Terminal and shell
  

  thunar # File manager
  gvfs thunar-archive-plugin thunar-media-tags-plugin thunar-volman thunar-shares-plugin
  file-roller # Archive manager
  
  etcher-bin  # Flashdrive maker
  peek        # Gif recorder
  scrot       # Screenshot captrure
  
  visual-studio-code-bin
  neovim helix

  node
  python3
  
  gnome-calculator

  google-chrome-stable

  spotify
  discord
  scrcpy

  obs-studio webcamoid
  vlc
  barrier
  
  gimp
  pinta # Paint-ish
  qview 

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
    yes "" | paru -Sy $app
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes "" | paru -Syyu


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
gsettings set org.gnome.desktop.interface gtk-theme Adwaita
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

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

#cd $HOME/Repositories
#git clone git@github.com:AndreasBrostrom/dotfiles.git
#cd $HOME/Repositories/dotfiles
#chmod +x install
#./install


#systemctl services
echo -e "\e[1;34mSetting up systemctl...\e[0m"

sudo systemctl enable --now paccache.timer

# Setup Greater
sudo mkdir -p /usr/share/lightdm-webkit/themes/
cd /usr/share/lightdm-webkit/themes/
git clone https://github.com/AndreasBrostrom/lightdm-webkit2-theme-minimal.git minimal

# Reset done
sudo --reset-timestamp
echo -e "done"
