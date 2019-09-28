#!/usr/bin/env bash

sudo apt update -y
sudo apt install snapd -y

sudo apt install git neovim opessh Python3 -y

sudo snap install code --classic

sudo snap install spotify

sudo snap install discord
sudo snap install slack --classic

sudo apt install steam-installer -y

echo Setting up path... 
echo "" >> ~/.bash_path
echo export PATH=$PATH:~/.scripts >>  .bash_path
echo "" >> ~/.bash_path
echo # Android >> ~/.bash_path
echo export ANDROID_HOME=$HOME/android-sdk >>  .bash_path
echo export PATH=$PATH:$ANDROID_HOME/tools/bin >>  .bash_path
echo export PATH=$PATH:$ANDROID_HOME/platform-tools >>  .bash_path
echo "" >> ~/.bash_path

echo Adding check for PATH in .bashrc... 
echo "" >> ~/.bashrc
echo # added PATH enviroments >> ~/.bashrc
echo if [ -f ~/.bash_path ]; then >> ~/.bashrc
echo     . ~/.bash_path >> .bashrc
echo fi >> ~/.bashrc
