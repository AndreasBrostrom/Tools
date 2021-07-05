#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

pacmanInstall=(
  dos2unix
  gh
  git
  jq
  nemo
  neovim
  python3
  python3-pip
  ripgrep
  terminator
  starship
)


SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
yes | sudo pacman -Syyu


echo -e "\e[1;34mInstalling general packages and tools...\e[0m"
for app in ${pacmanInstall[@]}; do
  echo "Installing $app and requirements..."
  yes | sudo pacman -Syy $app
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
yes | sudo pacman -Syyu

# Setup bashrc and home
echo -e "\e[1;34mSetting up home...\e[0m"

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

python3 $SCRIPTPATH/setupNewWSLHome.py

echo -e "done"
