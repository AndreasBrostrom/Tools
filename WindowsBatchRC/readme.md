# What is this?
This is a little regestry adjustment that allow you to setup a `.batchrc` in your home directory. The batchrc is built to mimic linux based systems using scripts in cobination with `DOSKEY` make it happen.
The `.batchrc` is loaded via the `AutoRun` each time you upen a CMD terminal.

```
C:\>cowsay Hi! This work in cmd!
 ____
< Hi! This work in cmd! >
 ----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

> ***NOTE!** At the moment you are required to add `.script` to your path variable `%USERPROFILE%\.scripts`*

# Avalible commands
- `cd` (custom cd setting home to ~)
- `ls`, ll, la, l
- `rm` (del)
- `cat` (type)
- `which` (where)
- `alias` (Show all marcos)
- `sys-update` (Run windows update and possible extentions)
- `source` (call)
- `hide` (set all .files and .folder to be hidden in the directory)
- `ifconfig` (ipconfig)
- `reboot` (shutdown)

## Avalible extentions
- Chocolatey
- Scoop
- WSL