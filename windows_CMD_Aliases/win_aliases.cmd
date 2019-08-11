@echo off

:: common commands
DOSKEY ls=dir /B
DOSKEY ll=dir /W
DOSKEY la=dir /B
DOSKEY l=dir /B

DOSKEY ifconfig=ipconfig /all

DOSKEY reboot=shutdown -r -t 0

DOSKEY rm=del $1

DOSKEY cat=type $1

:: Program
DOSKEY flash=Start "" D:\Tools\RockChip\RockChip_Batch_Tool_v1.8\RKBatchTool.exe
DOSKEY ryver=Start "" C:\\Users\\andre\\AppData\\Local\\ryver\\Ryver.exe

DOSKEY sys-update=C:\Users\andre\Tools\win-update.bat $1 $2 $3 $4 $5 $6 $7 $8 $9

if exist %WINDIR%/SYSTEM32/bash.exe (
    DOSKEY lx=bash.exe -c "$1 $2 $3 $4 $5 $6 $7 $8 $9"

    :: common
    DOSKEY cat=bash.exe -c "cat $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY ls=bash.exe -c "ls --color=auto $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY ll=bash.exe -c "ls -alF $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY la=bash.exe -c "ls -A $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY l=bash.exe -c "ls -CF $1 $2 $3 $4 $5 $6 $7 $8 $9"

    DOSKEY rm=bash.exe -c "rm $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY rmdir=bash.exe -c "rmdir $1 $2 $3 $4 $5 $6 $7 $8 $9"

    DOSKEY man=bash.exe -c "man $1 $2 $3 $4 $5 $6 $7 $8 $9"

    :: apt commands
    DOSKEY apt=bash.exe -c "sudo apt $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY apt-get=bash.exe -c "sudo apt-get $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY apt-cache=bash.exe -c "sudo apt-cache $1 $2 $3 $4 $5 $6 $7 $8 $9"

    :: editor
    DOSKEY vim=bash.exe -c "vim $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY nvim=bash.exe -c "nvim $1 $2 $3 $4 $5 $6 $7 $8 $9"

    :: random commands
    DOSKEY sl=bash.exe -c "sl $1 $2 $3 $4 $5 $6 $7 $8 $9"
    DOSKEY cowsay=bash.exe -c "cowsay $1 $2 $3 $4 $5 $6 $7 $8 $9"
)

DOSKEY alias=DOSKEY /MACROS
