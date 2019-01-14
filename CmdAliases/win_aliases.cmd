@echo off

:: common commands
DOSKEY ls=dir /B
DOSKEY ll=dir /W

DOSKEY ifconfig=ipconfig /all

DOSKEY reboot=shutdown -r

:: program > bash
DOSKEY vim=bash.exe -c 'vim $1 $2 $3 $4 $5 $6 $7 $8 $9'

:: apt commands > bash
DOSKEY apt=bash.exe -c 'apt $1 $2 $3 $4 $5 $6 $7 $8 $9'
DOSKEY apt-get=bash.exe -c 'apt-get $1 $2 $3 $4 $5 $6 $7 $8 $9'
DOSKEY sudo=bash.exe -c 'sudo $1 $2 $3 $4 $5 $6 $7 $8 $9'
DOSKEY vim=bash.exe -c 'vim $1 $2 $3 $4 $5 $6 $7 $8 $9'
DOSKEY nvim=bash.exe -c 'nvim $1 $2 $3 $4 $5 $6 $7 $8 $9'