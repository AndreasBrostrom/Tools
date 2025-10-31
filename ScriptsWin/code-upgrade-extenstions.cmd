@ECHO OFF
setlocal enabledelayedexpansion
set args=%*
:: replace problem characters in arguments
set args=%args:"='%
set args=%args:(=`(%
set args=%args:)=`)%
set invalid="=' 
if !args! == !invalid! ( set args= )

:: Check for pwsh, else fallback to powershell
where pwsh >nul 2>&1
if %errorlevel%==0 (
    set shell=pwsh
) else (
    set shell=powershell
)
%shell% -noprofile -ex unrestricted -command "& '%~dp0code-upgrade-extenstions.ps1' %args%; exit $lastexitcode"