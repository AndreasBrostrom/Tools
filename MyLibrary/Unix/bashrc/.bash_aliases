 
# Tools and systems
alias upgrade='sudo -S echo "Upgrading all system..." && sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo snap refresh; echo "All updates are completed.";'
alias sys-update='upgrade'

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Python
alias pip='pip3'
alias py='python3'
alias python='python3'

# Sudo
alias inperium='sudo'

# Program
alias vim='nvim'
alias terminal='terminator'

#alias ncspot='~/Library/ncspot/target/release/ncspot'
alias spotify='ncspot'
alias spotify-doc='google-chrome --app=https://github.com/hrkfdn/ncspot/blob/develop/README.md'

alias chrome='google-chrome'
alias screen='echo Running: scrcpy; scrcpy'
alias youtube='chrome --app=https://youtube.com/'

# Work VPN
alias hqvpn='sudo openconnect vpn.hq.playipp.com:10443'

# ADB shorts
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'
alias adb-p='adb-push'

alias adb-reload='adb-key -r'
alias adb-re='adb-reload'


# Git shortcuts
alias g-s='git status'
alias g-c='git checkout'

alias g-f='git fetch --all --prune'

alias g-r='git rebase'
alias g-u='git rebase master'

alias g-fr='g-f; g-r'
alias g-rf='g-fr'
alias g-fu='g-f; g-u'
alias g-uf='g-fu'

alias g-p='git stash'
alias g-pp='git stash pop'

alias g-frp='g-p; g-rf'
alias g-rfp='g-frp'
alias g-frpp='g-frp; g-pp'
alias g-rfpp='g-rfpp'
alias g-rmlocal='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'

# Termux
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    alias explorer='explorer.exe'
    alias calc='calc.exe'
    
    if [ command -v terminator >/dev/null 2>&1 ]; then terminator() { nohup terminator $* </dev/null >/dev/null 2>&1 & }; fi
    if [ command -v nemo >/dev/null 2>&1 ]; then nemo() { nohup nemo $* </dev/null >/dev/null 2>&1 & }; fi
fi

if [[ -d "/data/data/com.termux/" ]]; then
    alias sudo='su'

    alias upgrade='echo "Upgrading all system..." && apt update && apt full-upgrade -y && apt autoremove -y && pkg upgrade -y; echo "All updates are completed.";'
    alias sys-update='upgrade'

    alias toast='termux-toast -g top'
    alias call='termux-telephony-call'
    alias call-fluff='call 0764039604'
    alias contacts='termux-contact-list | jq'
    alias vol='termux-volume'
    alias vib='termux-vibrate -f'
    alias clip='termux-clipboard-set'
fi
