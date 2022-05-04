#!/data/data/com.termux/files/usr/bin/bash
pkgInstall=(
    git gh neovim
    dos2unix jq ripgrep
    python3
    openssh
    starship
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
cd $HOME

# Setting up home
[ ! -d "$HOME/Repositories" ] && mkdir -p $HOME/Repositories
[ ! -d "$HOME/.bin" ]         && mkdir -p $HOME/.bin

[ ! -d "$HOME/storage" ]       && ln -s /storage/emulated/0 storage
[ ! -d "$HOME/Documents" ]    && ln -s /storage/emulated/0/Documents Documents
[ ! -d "$HOME/Downloads" ]    && ln -s /storage/emulated/0/Download Downloads
[ ! -d "$HOME/Pictures" ]     && ln -s /storage/emulated/0/Pictures Pictures
[ ! -d "$HOME/Music" ]        && ln -s /storage/emulated/0/Music Music

if [ ! -d "$HOME/Repositories/Tools" ]; then
  cd $HOME/Repositories
  git clone https://github.com/AndreasBrostrom/Tools.git
fi
sed 's#https://github.com/AndreasBrostrom/Tools.git#git@github.com:AndreasBrostrom/Tools.git#g' $HOME/Repositories/Tools/.git/config
cd $HOME/Repositories/Tools/ScriptsLinux/
cp * $HOME/.bin

if [ ! -d "$HOME/Repositories/dotfiles" ]; then
  cd $HOME/Repositories
  git clone https://github.com/AndreasBrostrom/dotfiles.git
fi
sed 's#https://github.com/AndreasBrostrom/dotfiles.git#git@github.com:AndreasBrostrom/dotfiles.git#g' $HOME/Repositories/dotfiles/.git/config
cd $HOME/Repositories/dotfiles
chmod +x install
./install

echo -e "done"
