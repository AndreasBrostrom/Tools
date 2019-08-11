#!/bin/bash
cd "${0%/*}"

# Upgrade repo
sudo apt update -y
sudo apt full-upgrade -y

# Install programs
sudo apt install dos2unix -y
sudo apt install neovim -y

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
sudo dpkg -i ripgrep_11.0.2_amd64.deb

# Setup aliases
if [ ! -f ~/.bash_aliases ]; then
    touch ~/.bash_aliases
fi

echo "# sudo aliases" >> ~/.bash_aliases
echo "alias plz='sudo'" >> ~/.bash_aliases
echo "alias doit='sudo'" >> ~/.bash_aliases
echo "alias gogo='sudo'" >> ~/.bash_aliases
echo "alias ffs='sudo'" >> ~/.bash_aliases

echo "" >> ~/.bash_aliases
echo "# sys update" >> ~/.bash_aliases
echo "alias sys-update='sudo apt update -y; sudo apt full-upgrade -y; sudo apt autoremove -y; sudo snap refresh'" >> ~/.bash_aliases

echo "" >> ~/.bash_aliases
echo "# Program aliases" >> ~/.bash_aliases
echo "alias py='python3'" >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
