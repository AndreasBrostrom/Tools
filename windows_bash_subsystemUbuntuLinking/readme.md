

Add this around line 99 above the `.bash_aliases` in the `.bashrc`

```
# Windows Linux Subsystem to Ubuntu OS Linking
if [ -f ~/.bash_subsystem ]; then
    . ~/.bash_subsystem
fi
```



```
# Check for Ubuntu OS fiel system
if [ -d /mnt/f/root ]; then
  #echo "Ubuntu file system detected linking file systems."

  # Use Ubuntu system bash_aliases
  if [ -f /mnt/f/home/andre/.bash_aliases ]; then
    #echo "  .bash_aliases is loaded from the Ubuntu system."
    . /mnt/f/home/andre/.bash_aliases
  fi
fi

```