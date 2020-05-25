This is a little regestry adjustment that allow you to setup a "`.batchrc`" in your windows home (%USERPROFILE%). This batchrc system is built to mimic a linux terminal setup using scripts in cobination with `DOSKEY` (windows aliases) to make it happen.
The `.batchrc.cmd` is loaded via a regestry setup `AutoRun` each time you open a CMD terminal.

# Install
With a terminal place yourself in the download directory and run below commands

```ps
Expand-Archive "batchrc.zip" -DestinationPath "$Env:userprofile"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.scripts", "User")
reg import "add_batchrc.reg"
```

# Avalible alias commands
- `ls`, `ll`, `la`, `l` (dos command: `dir`)
- `rm` (dos command: `del`)
- `cat` (dos command: `type`)
- `which` (dos command: `where`)
- `alias` (dos command: `DOSKEY /MACROS`)
- `update` (run windows update and possible extentions)
- `source` (dos command: `call`)
- `ifconfig` (dos command: `ipconfig`)
- `source` (dos command: `call`)
- `reboot` (dos command: `shutdown -r -t 0`)

## Avalible extentions
- [Chocolatey](https://chocolatey.org/)
- [Scoop](https://scoop.sh/)
- [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)