#!/data/data/com.termux/files/usr/bin/bash
pkgInstall=(
    git gh neovim
    dos2unix jq ripgrep
    python3
    openssh
    starship
    iproute2
    termux-api x11-repo
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
mkdir -p $HOME/.bin
mkdir -p $HOME/.ssh

mkdir -p $HOME/Programs/bin
mkdir -p $HOME/Programs/lib
mkdir -p $HOME/Programs/src

mkdir -p $HOME/Repositories

echo -e " \033[2mLinking sdcard paths\033[0m"
ln -sf /storage/emulated/0 storage
ln -sf /storage/emulated/0/Documents Documents
ln -sf /storage/emulated/0/Download Downloads
ln -sf /storage/emulated/0/Pictures Pictures
ln -sf /storage/emulated/0/Music Music

# Setting up ssh permissions
if [ -d "$HOME/.ssh" ]; then
  echo -e "\033[1mFixing permission for ssh\033[0m"
  chmod 700 $HOME/.ssh
  chmod 600 $HOME/.ssh/config
  chmod 600 $HOME/.ssh/authorized_keys
  chmod 600 $HOME/.ssh/*id_rsa
  chmod 644 $HOME/.ssh/*.pub
fi

mkdir -p $HOME/.termux/boot/
echo """
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
""" > $HOME/.termux/boot/sshd
echo """
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
$HOME/.bin/monitor_dotfilestatus
""" > $HOME/.termux/boot/monitor_dotfilestatus

# clone and install tools and dotfiles
cd $HOME/Repositories

git clone git@github.com:AndreasBrostrom/dotfiles.git
cd $HOME/Repositories/dotfiles
chmod +x install
./install

# This is done in dotfiles now a days
#git clone git@github.com:AndreasBrostrom/Tools.git
#cd $HOME/Repositories/Tools/ScriptsLinux
#cp -f * $HOME/.bin/.

echo -e "done"
