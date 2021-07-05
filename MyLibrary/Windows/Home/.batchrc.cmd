@echo off

:: CD adjustments and path setting
if "%CD%" == "C:\Windows\system32" (set isWinSys32P=true)
if "%CD%" == "C:\Windows\System32" (set isWinSys32P=true)
if "%CD%" == "C:\WINDOWS\system32" (set isWinSys32P=true)
if "%CD%" == "C:\WINDOWS\System32" (set isWinSys32P=true)
if "%CD%" == "C:\WINDOWS\SYSTEM32" (set isWinSys32P=true)
if "%isWinSys32P%" == "true" (
   cd %userprofile%
)

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
:: Add path variables
IF EXIST %USERPROFILE%/.batch_path.cmd (
    call %USERPROFILE%/.batch_path.cmd
)
