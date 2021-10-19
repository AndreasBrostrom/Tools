#!/bin/bash
pkgInstall=(
    git gh neovim
    dos2unix jq ripgrep
    python3
  )

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
pkg upgrade -y

# Setup and install snap
echo -e "\e[1;34mInstalling pkg packages...\e[0m"
for app in ${pkgInstall[@]}; do
    echo "Installing $app and requirements..."
    pkg install -y $app
done

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
pkg upgrade -y

echo -e "\e[1;34mSetting up home...\e[0m"

# Setting up home
[ ! -d "$HOME/Repositories" ] && mkdir -p $HOME/Repositories
[ ! -d "$HOME/.bin" ]         && mkdir -p $HOME/.bin

[ ! -d "$HOME/sdcard" ]       && ln -s /sdcard/ sdcard
[ ! -d "$HOME/Documents" ]    && ln -s /sdcard/Documents/ Documents
[ ! -d "$HOME/Downloads" ]    && ln -s /sdcard/Downloads/ Downloads
[ ! -d "$HOME/Pictures" ]     && ln -s /sdcard/Pictures/ Pictures
[ ! -d "$HOME/Music" ]        && ln -s /sdcard/Music/ Music

cd $SCRIPTPATH/ScriptsLinux
cp * $HOME/.bin

cd $SCRIPTPATH/Repositories
if [ ! -d "$HOME/Repositories/dotfiles" ]; then
  git clone https://github.com/ColdEvul/dotfiles.git
fi
cd dotfiles
chmod +x install
./install

echo -e "done"
