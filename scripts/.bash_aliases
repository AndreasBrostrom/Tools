
alias dir='ls'

alias sys-update='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh; echo All updates are completed.'

# Python
alias pip='pip3'
alias py='python3'
alias python='python3'

# Sudo
alias please='sudo'
alias inperium='sudo'
alias root='sudo'
alias plz='sudo'
alias wtf='sudo'
alias doit='sudo'

# Program
alias vim='nvim'

alias ncspot='~/Program/ncspot/target/release/ncspot'
alias spotify='ncspot'
alias spotify-doc='google-chrome --app=https://github.com/hrkfdn/ncspot/blob/develop/README.md'

alias chrome='google-chrome'
alias screen='echo Running: scrcpy; scrcpy'
alias youtube='chrome --app=https://youtube.com/'
alias ryver='chrome --app=https://playipp.ryver.com/index.html#users/1494170/chat'
alias sneek='chrome --app=https://sneek.io/app/playipp'

# ADB shorts
alias adb-reverse='adb reverse tcp:8081 tcp:8081'
alias adb-r='adb-reverse'
alias adb-p='adb-push'

alias rn-android-uninstall='adb-u; rn-a'
alias rn-au='rn-android-uninstall'

# Git shortcuts
alias g-r='git rebase'
alias g-f='git fetch --all --prune'

alias g-fr='git fetch --all --prune; git rebase'
alias g-rf='g-fr'

alias g-s='git status'
alias g-c='git checkout'
alias g-u='git rebase master'

alias g-p='git stash'
alias g-pp='git stash pop'

alias g-frp='g-p; g-rf'
alias g-rfp='g-frp'
alias g-frpp='g-frp; g-pp' 
alias g-rfpp='g-rfpp'

