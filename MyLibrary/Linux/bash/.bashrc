
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Path Variables
if [ -f ~/.bash_path ]; then
  . ~/.bash_path
fi

# Windows Linux SubSytstem Terminal
if grep -iq 'microsoft' /proc/version &> /dev/null; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
  export LIBGL_ALWAYS_INDIRECT=1
  if [[ "$PWD" = "/mnt/c/Windows/system32" || "$PWD" = "/mnt/c/WINDOWS/system32" ]]; then
    cd ~
  fi
fi

# Android Termux Terminal
if [[ -d "/data/data/com.termux/" ]]; then
  cd
  clear
fi

# SSH Client Login
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  echo -e "\e[2;1mssh login \e[0;32;1m$USER@$HOSTNAME\e[0m"
fi

# Black Order Logo in Home
if [ -f $(which blackorder) ]; then
  [[ "$PWD" == "$HOME" ]] && blackorder
fi

# Terminal Prompt
if [ -f ~/.bash_prompt ]; then
  . ~/.bash_prompt
else
  PS1="\u@\h \w \$ "
fi

# ls Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lr='ls -ltrh'
alias lra='ls -ltrha'
alias dir='dir --color=auto'
alias dir='ls -l'
alias vdir='vdir --color=auto'

# grep Aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ex - archive extractor
# usage: ex <file>
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Cinnamon Desktop
if [ "$DESKTOP_SESSION" == "cinnamon" ]; then
  # Add an "alert" alias for long running commands.
  # usage: alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi
# i3 Desktop
# if [ "$DESKTOP_SESSION" == "i3" ]; then
# fi

# Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

