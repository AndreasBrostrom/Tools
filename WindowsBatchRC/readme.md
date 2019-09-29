# What is this?
This is a little regestry adjustment that sets up a `.batchrc` in your home directory using `DOSKEY` to set up aliases.
The aliases is loaded via the `AutoRun` each time you upen a CMD terminal.

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
- ls, ll, la, l
- ln (mklink)
- rm (del)
- cat (type)
- alias (Show all marcos)
- sys-update (Run windows update and possible extentions)
- source
- source-batchrc
- source-aliases
- hide (hide all .files and .folder)
- ifconfig (ipconfig)
- reboot (shutdown)

## Avalible extentions
- Chocolatey
- Scoop
- WSL