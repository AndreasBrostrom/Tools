#!/usr/bin/env bash

sudo apt update -y
sudo apt install snapd -y

sudo apt install git neovim opessh Python3 -y
sudo apt install android-sdk -y


sudo snap install code --classic

sudo snap install spotify

sudo snap install discord
sudo snap install slack --classic

sudo apt install steam-installer -y


echo Setting up .scripts... 
mkdir ~/.scripts
echo #!/usr/bin/env bash >> ~/.scripts/adb-push
echo "" >> ~/.scripts/adb-push
echo set -e >> ~/.scripts/adb-push
echo "" >> ~/.scripts/adb-push
echo adb push $1 /sdcard/Download/$2 >> ~/.scripts/adb-push
echo echo $1: have been pushed to ./sdcard/Download/$2 >> ~/.scripts/adb-push
echo "" >> ~/.scripts/adb-push
sudo chmod +x ~/.scripts


echo Setting up path... 
echo "" >> ~/.bash_path
echo export PATH=$PATH:~/.scripts >> .bash_path
echo "" >> ~/.bash_path
echo # Android >> ~/.bash_path
echo export ANDROID_HOME=$HOME/android-sdk >> .bash_path
echo export PATH=$PATH:$ANDROID_HOME/tools/bin >> .bash_path
echo export PATH=$PATH:$ANDROID_HOME/platform-tools >> .bash_path
echo "" >> ~/.bash_path


echo Adding check for PATH in .bashrc... 
echo "" >> ~/.bashrc
echo # added PATH enviroments >> ~/.bashrc
echo if [ -f ~/.bash_path ]; then >> ~/.bashrc
echo     . ~/.bash_path >> .bashrc
echo fi >> ~/.bashrc


echo Setting up .bash_aliases... 
echo "" >> ~/.scripts/adb-push
echo alias dir='ls' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias sys-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh; echo All updates are completed.' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo # Python >> ~/.bash_aliases
echo alias pip='pip3' >> ~/.bash_aliases
echo alias py='python3' >> ~/.bash_aliases
echo alias python='python3' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo # Sudo >> ~/.bash_aliases
echo alias please='sudo' >> ~/.bash_aliases
echo alias inperium='sudo' >> ~/.bash_aliases
echo alias root='sudo' >> ~/.bash_aliases
echo alias plz='sudo' >> ~/.bash_aliases
echo alias wtf='sudo' >> ~/.bash_aliases
echo alias doit='sudo' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo # Program >> ~/.bash_aliases
echo alias vim='nvim' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias ncspot='~/Program/ncspot/target/release/ncspot' >> ~/.bash_aliases
echo alias spotify='ncspot' >> ~/.bash_aliases
echo alias spotify-doc='google-chrome --app=https://github.com/hrkfdn/ncspot/blob/develop/README.md' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias chrome='google-chrome' >> ~/.bash_aliases
echo alias screen='echo Running: scrcpy; scrcpy' >> ~/.bash_aliases
echo alias youtube='chrome --app=https://youtube.com/' >> ~/.bash_aliases
echo alias ryver='chrome --app=https://playipp.ryver.com/index.html#users/1494170/chat' >> ~/.bash_aliases
echo alias sneek='chrome --app=https://sneek.io/app/playipp' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo # ADB shorts >> ~/.bash_aliases
echo alias adb-reverse='adb reverse tcp:8081 tcp:8081' >> ~/.bash_aliases
echo alias adb-r='adb-reverse' >> ~/.bash_aliases
echo alias adb-p='adb-push' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias rn-android-uninstall='adb-u; rn-a' >> ~/.bash_aliases
echo alias rn-au='rn-android-uninstall' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo # Git shortcuts >> ~/.bash_aliases
echo alias g-r='git rebase' >> ~/.bash_aliases
echo alias g-f='git fetch --all --prune' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias g-fr='git fetch --all --prune; git rebase' >> ~/.bash_aliases
echo alias g-rf='g-fr' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias g-s='git status' >> ~/.bash_aliases
echo alias g-c='git checkout' >> ~/.bash_aliases
echo alias g-u='git rebase master' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias g-p='git stash' >> ~/.bash_aliases
echo alias g-pp='git stash pop' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases
echo alias g-frp='g-p; g-rf' >> ~/.bash_aliases
echo alias g-rfp='g-frp' >> ~/.bash_aliases
echo alias g-frpp='g-frp; g-pp'  >> ~/.bash_aliases
echo alias g-rfpp='g-rfpp' >> ~/.bash_aliases
echo "" >> ~/.bash_aliases