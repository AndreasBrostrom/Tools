#!/bin/bash

aptInstallAllSystems=(
    git neovim
    android-sdk dos2unix jq ripgrep cargo ninja-build
    python3 python3-pip
    openjdk-8-jdk
  )
aptInstallLinuxSystem=(
    terminator
    gparted
    i3-wm suckless-tools i3status i3lock
    grub-customizer
    steam-installer
    snapd
  )
aptInstallWinSystem=(
  nemo
  )
snapInstallLinuxSystem=(
    code--classic
    powershell--classic
    spotify
    discord
    slack--classic
    scrcpy
    vlc
  )


SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"

sudo apt update -y
echo -e "\e[1;34mPreforming full upgrade for all packages stand by...\e[0m"
sudo apt full-upgrade -y


echo -e "\e[1;34mInstalling general packages and tools...\e[0m"
for app in ${aptInstallAllSystems[@]}; do
  echo "Installing $app and requirements..."
  sudo apt install $app -y 1>/dev/null 2>&1
done

# Setup and install snap
if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo -e "\e[1;34mInstalling linux apt packages...\e[0m"
  for app in ${aptInstallLinuxSystem[@]}; do
    echo "Installing $app and requirements..."
    sudo apt install $app -y 1>/dev/null 2>&1
  done

  echo -e "\e[1;34mInstalling snap packages...\e[0m"
  for snap in ${snapInstallLinuxSystem[@]}; do
    echo "Installing snap $(sed "s/--classic/ with classic/g" <<< $snap)..."
    sudo snap install $(sed "s/--/ --/g" <<< $snap) -y 1>/dev/null 2>&1
  done
fi

echo -e "\e[1;34mPreforming final checks and cleaning...\e[0m"
sudo apt full-upgrade -y 1>/dev/null 2>&1
sudo apt autoremove -y 1>/dev/null 2>&1
sudo apt autoclean -y 1>/dev/null 2>&1


# Setup WSL if exist
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    python3 setupNewWSL.py
    echo -e "\e[1;34mInstalling WSL packages and tools...\e[0m"
    for app in ${aptInstallWinSystem[@]}; do
      echo "Installing $app and requirements..."
      sudo apt install $app -y 1>/dev/null 2>&1
    done
fi

# Setup Android SDK location
if ! grep -iq 'microsoft' /proc/version &> /dev/null; then
  echo -e "\e[1;34mFixing android SDK...\e[0m"
  mkdir $HOME/.android 1>/dev/null 2>&1
  mv $HOME/android-sdk $HOME/.android/android-sdk 1>/dev/null 2>&1
fi

# Setup bashrc and home
echo -e "\e[1;34mSetting up home...\e[0m"
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.profile" $HOME/.profile
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bashrc" $HOME/.bashrc
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_path" $HOME/.bash_path
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_aliases" $HOME/.bash_aliases
cp "$SCRIPTPATH/../MyLibrary/Unix/bashrc/.bash_prompt" $HOME/.bash_prompt
dos2unix $HOME/.bash*
dos2unix $HOME/.profile

# Nemo
mkdir -p $HOME/.local/share/nemo/actions/
cp "$SCRIPTPATH/../MyLibrary/Unix/nemo/code.nemo_action" $HOME/.local/share/nemo/actions/code.nemo_action
cp "$SCRIPTPATH/../MyLibrary/Unix/nemo/sort_actions.sh" $HOME/.local/share/nemo/actions/sort_actions.sh
dos2unix $HOME/.local/share/nemo/actions/*

# Templates
mkdir -p $HOME/Templates/
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/Bash script file.sh" "$HOME/Templates/Bash script file.sh"
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/Python script file.py" "$HOME/Templates/Python script file.py"
cp "$SCRIPTPATH/../MyLibrary/Unix/Templates/SQF script file.sqf" "$HOME/Templates/SQF script file.sqf"
dos2unix $HOME/Templates/*

mkdir -p $HOME/.config
cp -r "$SCRIPTPATH/../MyLibrary/Unix/.config" "$HOME/."
dos2unix $HOME/.config/gtk-2.0/*
dos2unix $HOME/.config/gtk-3.0/*
dos2unix $HOME/.config/i3/*

# Setup some scripts
mkdir $HOME/.bin  1>/dev/null 2>&1
mkdir -p $HOME/Programs/bin 1>/dev/null 2>&1
cp "$SCRIPTPATH/../Scripts/adb-key" $HOME/.bin/adb-key
cp "$SCRIPTPATH/../Scripts/adb-push" $HOME/.bin/adb-push
dos2unix $HOME/.bin/*



echo -e "done"
