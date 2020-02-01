 
# Tools and systems
alias dir='ls -l'
alias sys-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh; echo All updates are completed.'
alias lock='cinnamon-screensaver-command -l; xset dpms force off'

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

alias ncspot='~/Library/ncspot/target/release/ncspot'
alias spotify='ncspot'
alias spotify-doc='google-chrome --app=https://github.com/hrkfdn/ncspot/blob/develop/README.md'

alias chrome='google-chrome'
alias screen='echo Running: scrcpy; scrcpy'
alias youtube='chrome --app=https://youtube.com/'

# ADB shorts
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'
alias adb-p='adb-push'

# Git shortcuts
alias g-s='git status'
alias g-c='git checkout'

alias g-r='git rebase'
alias g-u='git rebase origin/master'

alias g-f='git fetch --all --prune'

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

# Termux
if [[ -d "/data/data/com.termux/" ]]; then
    alias sudo='su'
    alias sys-update='apt update && apt full-upgrade -y && apt autoremove -y;'
    alias toast='termux-toast -g top'
    alias call='termux-telephony-call'
    alias call-fluff='call 0764039604'
    alias contacts='termux-contact-list | jq'
    alias vol='termux-volume'
    alias vib='termux-vibrate -f'
    alias clip='termux-clipboard-set'
fi
