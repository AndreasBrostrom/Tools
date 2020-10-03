 
# Upgrade
if [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "ubuntu" ]; then
    alias upgrade='sudo -S echo "Upgrading all system..."; sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && echo "Checking Flatpak..."; flatpak update -y && sudo snap refresh; echo "All updates are completed.";'
fi
if [ "$(cat /etc/os-release | grep ID_LIKE | cut -f 2 -d '=')" == "arch" ]; then
    alias upgrade='sudo -S echo "Upgrading all system..."; sudo pacman -Syyu && echo "Checking Flatpak...";flatpak update -y && sudo snap refresh; echo "All updates are completed.";'
fi
if [[ -d "/data/data/com.termux/" ]]; then
    alias upgrade='echo "Upgrading all system..." && apt update && apt full-upgrade -y && apt autoremove -y && pkg upgrade -y; echo "All updates are completed.";'
fi

# cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Python
[[ "$(which pip3 1>/dev/null 2>&1; echo $?)" == "0"          ]] && alias pip='pip3'
[[ "$(which python3 1>/dev/null 2>&1; echo $?)" == "0"       ]] && alias py='python3'
[[ "$(which python3 1>/dev/null 2>&1; echo $?)" == "0"       ]] && alias python='python3'


# Program
[[ "$(which nvim 1>/dev/null 2>&1; echo $?)" == "0"          ]] && alias vim='nvim'
[[ "$(which terminator 1>/dev/null 2>&1; echo $?)" == "0"    ]] && alias terminal='terminator'

[[ "$(which google-chrome 1>/dev/null 2>&1; echo $?)" == "0" ]] && alias chrome='google-chrome'
[[ "$(which emulator 1>/dev/null 2>&1; echo $?)" == "0"      ]] && alias chrome='~/.scripts/emulator_proxy'
[[ "$(which scrcpy 1>/dev/null 2>&1; echo $?)" == "0"        ]] && alias screen='scrcpy'


# ADB shorts
if [[ "$(which adb 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias adb-reverse='adb reverse tcp:8081 tcp:8081'
    alias adb-r='adb-reverse'
    [[ -f $(which adb-push 1>/dev/null 2>&1)  ]] && alias adb-p='adb-push'

    alias adb-reload='adb-key -r'
    alias adb-re='adb-reload'

    alias adb-u='adb uninstall com.playipp.connect &>/dev/null'

    alias logcat='adb logcat'
fi

# React native
if [[ "$(which react-native 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias rn='react-native'
    alias rn-s='
        if [[ $(grep -q "\"react-native\":" package.json 2&>/dev/null || echo "1") -eq 0 ]]; then
            rn start
        elif [[ $(grep -q "\"react\":" package.json 2&>/dev/null || echo "1") -eq 0 ]]; then
            yarn start
        else
            echo "Not a react-native or react project..."
        fi'
    alias rn-p='
        if [[ $(grep -q "\"react-native\":" package.json 2&>/dev/null || echo "1") -eq 0 ]]; then
            [[ -d "./android" ]] && echo -e "\e[1mCleaning gradlew...\e[0m"; cd android; ./gradlew clean; cd .. &&
            [[ -d "./node_modules" ]] && (echo -en "\e[1mClearing node_modules...\e[0m"; rm -fr node_modules/; echo -e "\e[1m Done\e[0m") &&
            echo -e "\e[1mInstalling moduels...\e[0m"; yarn &&
            rn start --reset-cache;
        elif [[ $(grep -q "\"react\":" package.json 2&>/dev/null || echo "1") -eq 0 ]]; then
            [[ -d "node_modules" ]] && (echo -en "\e[1mClearing node_modules...\e[0m"; rm -fr node_modules/; echo -e "\e[1m Done\e[0m") &&
            echo -e "\e[1mInstalling moduels...\e[0m"; yarn &&
            yarn start
        else
            echo "Not a react-native or react project..."
        fi'
    alias rn-a='rn run-android'
    alias rn-i='rn run-ios'
    alias rn-w='rn-s'

    alias rn-au='adb-u; rn-a; adb-r'
    alias rn-ua='rn-au'

    alias rn-reload='adb-reload'
    alias rn-re='adb-reload'
fi

# Git shortcuts
if [[ "$(which git 1>/dev/null 2>&1; echo $?)" == "0" ]]; then
    alias g-s='git status'
    alias g-c='git checkout'
    alias g-b='git branch'
    alias g-f='git fetch --all --prune'
    alias g-r='git rebase'
    alias g-u='git rebase master'
    alias g-pu='git push'
    alias g-puf='git push fork'
    alias g-puff='git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD)'
    alias g-fr='g-f; g-r'
    alias g-rf='g-fr'
    alias g-fu='g-f; g-u'
    alias g-uf='g-fu'

    alias g-p='git stash'
    alias g-pp='git stash pop'

    alias g-cp='g-p; g-c'
    alias g-frp='g-p; g-rf'
    alias g-rfp='g-frp'
    alias g-frpp='g-frp; g-pp'
    alias g-rfpp='g-rfpp'
    g-brmlocal () {
        echo "Clearing merged/gone local branches..."
        git fetch -p
        for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
        git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d 2&>/dev/null
        echo -e "Cleaning completed."
        if [[ $(git branch -vv | cut -c 3- | awk '$3 !~/\[/') ]]; then
            echo -e "\nFollowing branches have no remote:"
            git branch -vv | cut -c 3- | awk '$3 !~/\[/ { print " > "$1 }'
        fi
    }
fi

# Windows Linux SubSytstem
if grep -iq 'microsoft' /proc/version &> /dev/null; then
    alias explorer='explorer.exe'
    alias calc='calc.exe'
    
    alias terminator='detach terminator'
    alias nemo='detach nemo'
fi

# Android Termux Terminal
if [[ -d "/data/data/com.termux/" ]]; then
    alias upgrade='echo "Upgrading all system..." && apt update && apt full-upgrade -y && apt autoremove -y && pkg upgrade -y; echo "All updates are completed.";'
    
    alias sudo='su'
    
    alias toast='termux-toast -g top'
    alias call='termux-telephony-call'
    alias call-fluff='call 0764039604'
    alias contacts='termux-contact-list | jq'
    alias vol='termux-volume'
    alias vib='termux-vibrate -f'
    alias clip='termux-clipboard-set'
fi
