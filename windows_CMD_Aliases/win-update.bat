@echo off

echo Checking for windows updates...
echo This can take some time stand by...
UsoClient StartScan
UsoClient StartDownload
UsoClient StartInstall

:: If WSL is detected ask to update that as well:
IF NOT EXIST %WINDIR%\system32\bash.exe GOTO :done
    echo Windows Subsystem for Linux detected...
    echo Updating packages...
    bash.exe -c "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y; sudo snap refresh;"

:: If CHOCO is detected ask to update that as well:
IF NOT EXIST %ChocolateyInstall%\choco.exe GOTO :done
    echo Chocolatey detected...
IF EXIST %ChocolateyInstall%\lib\wsudo GOTO :updateChoco
    echo Package dependency does not exist 'wsudo' please run in a elevated terminal:
    echo   choco install wsudo
:updateChoco
    echo Updating packages...
    wsudox choco upgrade all -y

:done
    UsoClient RestartDevice

echo All updates is completed.