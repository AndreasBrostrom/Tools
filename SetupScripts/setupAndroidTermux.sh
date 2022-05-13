#!/data/data/com.termux/files/usr/bin/bash
pkgInstall=(
    git gh neovim
    dos2unix jq ripgrep
    python3
    openssh
    starship
  )

echo -e "\033[34;1mSetting up a new terminal...\033[0m"

echo -e "\033[1mPreforming full upgrade for all packages stand by...\033[0m"
pkg upgrade -y

# Setup and install snap
echo -e "\033[1mInstalling pkg packages\033[0m"
for app in ${pkgInstall[@]}; do
  echo -e "\033[2mInstalling $app and requirements...\033[0m"
  pkg install -y $app
done

echo -e "\033[1mPreforming final checks and cleaning...\033[0m"
pkg upgrade -y

echo -e "\033[1mSetting up home directory\033[0m"
cd $HOME

# Setting up home
echo -e " \033[2mCreating folders\033[0m"
[ ! -d "$HOME/Repositories" ] && mkdir -p $HOME/Repositories
[ ! -d "$HOME/.bin" ]         && mkdir -p $HOME/.bin
[ ! -d "$HOME/.ssh" ]         && mkdir -p $HOME/.ssh

echo -e " \033[2mLinking sdcard paths\033[0m"
[ ! -d "$HOME/storage" ]      && ln -s /storage/emulated/0 storage
[ ! -d "$HOME/Documents" ]    && ln -s /storage/emulated/0/Documents Documents
[ ! -d "$HOME/Downloads" ]    && ln -s /storage/emulated/0/Download Downloads
[ ! -d "$HOME/Pictures" ]     && ln -s /storage/emulated/0/Pictures Pictures
[ ! -d "$HOME/Music" ]        && ln -s /storage/emulated/0/Music Music

# Setting up ssh permissions
if [ -d "$HOME/.ssh" ]; then
  echo -e "\033[1mFixing permission for ssh\033[0m"
  chmod 700 $HOME/.ssh
  chmod 600 $HOME/.ssh/config
  chmod 600 $HOME/.ssh/authorized_keys
  chmod 600 $HOME/.ssh/*id_rsa
  chmod 644 $HOME/.ssh/*.pub
fi

# clone and install tools and dotfiles
if [ ! -d "$HOME/Repositories/dotfiles" ]; then
  cd $HOME/Repositories
  git clone git@github.com:AndreasBrostrom/dotfiles.git
fi
cd $HOME/Repositories/dotfiles
chmod +x install
./install

echo -e "done"
