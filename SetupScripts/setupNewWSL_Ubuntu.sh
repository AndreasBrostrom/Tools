#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

aptInstall=(
  dos2unix jq ripgrep exa xdotool
  python3 python3-pip

  terminator
  fish starship

  thunar
)


# Setup and install
echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
sudo apt update -y
sudo apt full-upgrade -y

echo -e "\e[1;34mInstalling general packages and tools...\e[0m"
for app in ${aptInstall[@]}; do
  echo "Installing $app and requirements..."
  sudo apt install $app -y
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
sudo apt full-upgrade -y 1>/dev/null 2>&1
sudo apt autoremove -y 1>/dev/null 2>&1
sudo apt autoclean -y 1>/dev/null 2>&1


# Setup bashrc and home
echo -e "\e[1;34mSetting up home...\e[0m"

# Setting up home
mkdir -p $HOME/Programs
mkdir -p $HOME/Programs/bin
mkdir -p $HOME/Programs/opt
mkdir -p $HOME/Programs/src
mkdir -p $HOME/Repositories
ln -sf $HOME/Programs/bin $HOME/.bin

echo -e " \033[2mFixing SSH permissions\033[0m"
mkdir -p $HOME/.ssh
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


python3 <(curl -s https://raw.githubusercontent.com/AndreasBrostrom/Tools/master/SetupScripts/setupNewWSLHome.py)

echo -e "done"
