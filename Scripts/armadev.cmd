@ECHO OFF
setlocal enabledelayedexpansion
set args=%*
:: replace problem characters in arguments
set args=%args:"='%
set args=%args:(=`(%
set args=%args:)=`)%
set invalid="='
if !args! == !invalid! ( set args= )
pwsh -noprofile -ex unrestricted -command "& '%USERPROFILE%\.bin\armadev.ps1' %args%; exit $lastexitcode"
