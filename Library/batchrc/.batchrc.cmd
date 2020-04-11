@echo off

:: Set prompt to unix like
SET PROMPT_P=[34m$P[0m$S
SET PROMPT_E=$G$S
SET PROMPT_DEF=%PROMPT_U%%PROMPT_P%%PROMPT_E%
PROMPT %PROMPT_DEF%

:: CD adjustments and path setting
if "%CD%" == "C:\Windows\system32" set isWinSys32P=true
if "%CD%" == "C:\Windows\System32" set isWinSys32P=true
if "%CD%" == "C:\WINDOWS\System32" set isWinSys32P=true
if "%CD%" == "C:\WINDOWS\SYSTEM32" set isWinSys32P=true
if "%isWinSys32P%" == "true" (
   cd %userprofile%
)

:: Full system update
DOSKEY sys-update=cmd.exe /c %USERPROFILE%/.scripts/upgrade.cmd
DOSKEY upgrade=cmd.exe /c %USERPROFILE%/.scripts/upgrade.cmd

:: Windows dir macro extentions
DOSKEY ls=dir /B $*
DOSKEY ll=dir $*
DOSKEY la=dir /A $*
DOSKEY l=dir /W $*

:: Windows Unix extentions
DOSKEY cat=type $*
DOSKEY rm=del $*
DOSKEY which=where $*

DOSKEY reboot=shutdown -r -t 0
DOSKEY ifconfig=ipconfig /all $*

DOSKEY source=call $*

:: batch aliases list
DOSKEY alias=DOSKEY /MACROS

:: Additional aliases defined in batch aliases
IF EXIST %USERPROFILE%/.batch_aliases.cmd (
    call %USERPROFILE%/.batch_aliases.cmd
)
