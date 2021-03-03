#!/bin/bash

if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo "This is not WSL"
  exit 1
fi

aptInstall=(
  git
  neovim
  dos2unix
  jq
  ripgrep
  cargo
  ninja-build
  python3 python3-pip
  openjdk-8-jdk
  terminator
  nemo
)


SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

sudo apt update -y
echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
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
cp "$SCRIPTPATH/../MyLibrary/Linux/bash/.profile" $HOME/.profile
cp "$SCRIPTPATH/../MyLibrary/Linux/bash/.bashrc" $HOME/.bashrc
cp "$SCRIPTPATH/../MyLibrary/Linux/bash/.bash_profile" $HOME/.bash_profile
cp "$SCRIPTPATH/../MyLibrary/Linux/bash/.bash_path" $HOME/.bash_path
cp "$SCRIPTPATH/../MyLibrary/Linux/bash/.bash_aliases" $HOME/.bash_aliases
dos2unix $HOME/.bash*
dos2unix $HOME/.profile

# Setup some scripts
mkdir $HOME/.bin  1>/dev/null 2>&1
mkdir -p $HOME/Programs/bin 1>/dev/null 2>&1
mkdir -p $HOME/Repositories 1>/dev/null 2>&1
cp "$SCRIPTPATH/../Scripts/adb-key" $HOME/.bin/adb-key
cp "$SCRIPTPATH/../Scripts/adb-pull" $HOME/.bin/adb-pull
cp "$SCRIPTPATH/../Scripts/adb-push" $HOME/.bin/adb-push
cp "$SCRIPTPATH/../Scripts/detach" $HOME/.bin/detach
dos2unix $HOME/.bin/*

python3 $SCRIPTPATH/setupNewWSLHome.py

echo -e "done"
