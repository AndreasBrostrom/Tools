#Requires -RunAsAdministrator
if ("$Env:OS" -ne "Windows_NT") { Write-Host "Your not running on a Windows shell..." -ForegroundColor Red; exit }    

# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# GLOBALS
$scoop_buckets    = 'extras', 'Arma3Tools https://github.com/ColdEvul/arma3-scoop-bucket.git'

$scoop_pkg        = 'git', 'curl',
                    'grep', 'ripgrep', 'sed', 'touch', 'jq', 'dos2unix',
                    'neovim', 'gdrive', 'scrcpy',
                    'python', 'ruby', 'msys2', 'perl', 'ninja', 'rust',
                    'steamcmd', 'qbittorrent-portable', 'android-sdk', 'rufus',
                    'armake', 'hemtt'

$choco_pkg        = 'DotNet4.5.2', 'vcredist140', 'vcredist2015', 'vcredist2017', 'KB2919355', 'KB2919442', 'KB2999226', 'KB3033929', 'KB3035131', 
                    'googlechrome', 'vscode',
                    'microsoft-windows-terminal',
                    'winrar', 'vlc', 'spotify', 'teamviewer', 
                    #'TortoiseGit',
                    'teamspeak', 'discord', 'slack',
                    'steam',
                    'obs-studio',
                    'powershell-core', 'ext2fsd --version=0.68.0.20161111', 'windows-tweaker', 'winaero-tweaker'

$pwsh_modules     = 'PSWindowsUpdate', 'Get-ChildItemColor'

# Script start
Write-Host "Starting up..." -ForegroundColor Blue



# Installing scoop
Write-Host "Setting up Scoop..." -ForegroundColor Blue
if (![System.IO.File]::Exists("$env:USERPROFILE\scoop\shims\scoop")) {
    Write-Host "Installing Scoop..." -ForegroundColor Blue
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') >$null 2>&1
} else {
    Write-Host "Scoop already exist no need to install. Checking for updates..." -ForegroundColor Yellow
    scoop update scoop >$null 2>&1
}

# Add scoop buckets
Write-Host "Adding Scoop buckets..."
foreach ($buckets in $scoop_buckets) {
    scoop bucket add $buckets >$null 2>&1
}

# Install scoop packages
Write-Host "Installing Scoop packages..."
# Basic Packages
$scoop_defult_pkg = 'sudo', 'aria2', '7zip'
foreach ($pkg in $scoop_defult_pkg) {
    if (![System.IO.Directory]::Exists("$env:USERPROFILE\scoop\apps\$pkg")) {
        Write-Host "Installing $pkg..."
        scoop install $pkg >$null 2>&1
    } else {
        Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
    }
}
foreach ($pkg in $scoop_pkg) {
    if (![System.IO.Directory]::Exists("$env:PROGRAMDATA\scoop\apps\$pkg")) {
        Write-Host "Installing $pkg..."
        scoop install $pkg -g >$null 2>&1
    } else {
        Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
    }
}
Write-Host "Installation of scoop packages completed..." -ForegroundColor Green



# Installing Chocolately
Write-Host "Setting up Chocolately..." -ForegroundColor Blue
if (![System.IO.File]::Exists("C:\ProgramData\chocolatey\choco.exe")) {
    Write-Host "Installing Chocolately..." -ForegroundColor green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Changeing and setting some paths for Chocolately..."
    choco feature enable -n allowGlobalConfirmation >$null 2>&1
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")
} else { Write-Host "Chocolately already exist..." -ForegroundColor Yellow }

# Chocolately packages
Write-Host "Installing Chocolately packages..."
foreach ($pkg in $choco_pkg) {
    choco search $pkg --local >$null 2>&1
    if (!$?) {
        Write-Host "Installing $pkg..."
        choco install $pkg >$null 2>&1
    } else {
        Write-Host "Choco $pkg already installed skipping..." -ForegroundColor Yellow
    }
}
Write-Host "Installation of chocolately packages completed..." -ForegroundColor Green



# Install powershell moduels
Write-Host "Powershell modules..."
foreach ($module in $pwsh_modules) {
    Install-Module -Name $module >$null 2>&1
}
Write-Host "Powershell module installation completed..." -ForegroundColor Green



# Download drives and packages for gaming
Write-Host "Downloading drives and programs for gaming..." -ForegroundColor Blue
Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile\Downloads\TrackIR_5.4.2.exe" >$null 2>&1

Invoke-WebRequest https://media.roccat.org/driver/Tyon/ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip -OutFile "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" >$null 2>&1
Expand-Archive "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" -DestinationPath "$Env:userprofile\Downloads\" >$null 2>&1
Remove-Item "$Env:userprofile\Downloads\ROCCAT_Tyon_DRV1.17_FW1.34forAlienFx-v1.zip" >$null 2>&1

Invoke-WebRequest https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.02.65_x64_Logitech.exe -OutFile "$Env:userprofile/Downloads/LGS_9.02.65_x64_Logitech.exe" >$null 2>&1

Write-Host "Drives packages downloaded and ready..." -ForegroundColor Green



# Setting up home enviroment
if (![System.IO.Directory]::Exists("$Env:userprofile\.scripts")) {
    Write-Host "Setting up home..."

    New-Item -itemtype "directory" -path "$Env:userprofile\.scripts"
    (get-item $Env:userprofile\.scripts).Attributes += 'Hidden'
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.scripts", "User")

    New-Item -itemtype "directory" -path "C:\Programs"
    New-Item -itemtype Junction -path "$Env:userprofile" -name "Programs" -value "C:\Programs"

    New-Item -itemtype "directory" -path "C:\Programs\Bin"
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Programs\Bin", "Machine")

    Write-Host "Setting up symbolic links and directories..."
    New-Item -itemtype Junction -path "C:\" -name "Tmp" -value "$Env:temp"

    New-Item -itemtype "directory" -path "C:\Program Files (x86)\Steam\steamapps\common"
    New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Program Files (x86)\Steam\steamapps\common"
} else {
    Write-Host "Home already setup skipping..." -ForegroundColor Yellow
}

    # Setup cmd
if (![System.IO.File]::Exists("$Env:userprofile\.batchrc.cmd")) {
    Write-Host "Configurating CMD..." -ForegroundColor Blue
    #Expand-Archive "$PSScriptRoot\..\WindowsBatchRC\batchrc.zip" -DestinationPath "$Env:userprofile"
    reg import "$PSScriptRoot\..\WindowsBatchRC\add_batchrc.reg" >$null 2>&1

    Copy-Item "$PSScriptRoot\..\Library\batchrc\.batchrc.cmd" -Destination "$Env:userprofile\"
    Copy-Item "$PSScriptRoot\..\Library\batchrc\.batch_aliases.cmd" -Destination "$Env:userprofile\"
    Copy-Item "$PSScriptRoot\..\Library\batchrc\.scripts" -Destination "$Env:userprofile\" -Recurse

    Write-Host "Configuration of CMD complete..." -ForegroundColor Green
} else {
    Write-Host "CMD already configured skipping..." -ForegroundColor Yellow
}

# Setup powershell profile
if (![System.IO.File]::Exists("$Env:userprofile\Documents\PowerShell\profile.ps1")) {
    Write-Host "Configurating Powershell..." -ForegroundColor Blue
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\PowerShell\"
    (get-item $Env:userprofile\Documents\PowerShell).Attributes += 'Hidden'
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\WindowsPowerShell\"
    (get-item $Env:userprofile\Documents\WindowsPowerShell).Attributes += 'Hidden'

    if ([System.IO.File]::Exists("$PSScriptRoot\..\Library\PowershellProfile\profile.ps1")) {
        Write-Host "Profile restored..."
        Copy-Item "$PSScriptRoot\..\Library\PowershellProfile\profile.ps1" -Destination "$Env:userprofile\Documents\PowerShell\"
    } else {
        Write-Host "Creating empty profile..."
        New-Item -itemtype "file" -path "$Env:userprofile\Documents\PowerShell\profile.ps1"
    }
    New-Item -itemtype SymbolicLink -path "$Env:userprofile" -name ".psrc" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
    New-Item -itemtype SymbolicLink -path "$Env:userprofile\Documents\WindowsPowerShell" -name "profile.ps1" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
    (get-item $Env:userprofile\.psrc).Attributes += 'Hidden'

    Write-Host "Configuration of PowerShell complete..." -ForegroundColor Green
} else {
    Write-Host "Powershell already configured skipping..." -ForegroundColor Yellow
}



# Creating quick links for terminal
if (![System.IO.Directory]::Exists("C:\ProgramData\Chocolatey\shims")) {
    Write-Host "Setting up shims..." -ForegroundColor Blue
    New-Item -itemtype "directory" -path "C:\ProgramData\Chocolatey\shims"
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\shims", "Machine")

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\choco" -p="C:\ProgramData\Chocolatey\choco.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome.exe" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\google-chrome" -p="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam.exe" -p="C:\Program Files (x86)\Steam\Steam.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\steam" -p="C:\Program Files (x86)\Steam\Steam.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code.exe" -p="C:\Program Files\Microsoft VS Code\Code.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\code" -p="C:\Program Files\Microsoft VS Code\Code.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify.exe" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\spotify" -p="$Env:userprofile\AppData\Roaming\Spotify\Spotify.exe" >$null 2>&1

    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer.exe" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe" >$null 2>&1
    C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\ProgramData\Chocolatey\shims\TeamViewer" -p="C:\Program Files (x86)\TeamViewer\TeamViewer.exe" >$null 2>&1
} else {
    Write-Host "Shims already setup for common programs skipping..." -ForegroundColor Yellow
}


Write-Host "Adjusting the context menu..." -ForegroundColor Blue
reg import "$PSScriptRoot\..\VSCode\Elevation_Add.reg" >$null 2>&1

reg import "$PSScriptRoot\..\CustomNewFileRegFiles\!cleanUnwantedCreateNewFile.reg" >$null 2>&1
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewCppFile.reg" >$null 2>&1
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewHppFile.reg" >$null 2>&1
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewMdFile.reg" >$null 2>&1
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewPythonFile.reg" >$null 2>&1
reg import "$PSScriptRoot\..\CustomNewFileRegFiles\addCreateNewSqfFile.reg" >$null 2>&1

# Terminals
reg import "$PSScriptRoot\..\WindowsTerminal\add_windowsTerminal.reg" >$null 2>&1
#reg import "$PSScriptRoot\..\WindowsContextMenu\Cmd_Powershell\CMDOnShellHack.reg" >$null 2>&1
#reg import "$PSScriptRoot\..\Powershell6\Add_Powershell6_context.reg" >$null 2>&1

# Change windows time
reg import "$PSScriptRoot\..\WindowsUTCTime\Make Windows Use UTC Time.reg" >$null 2>&1

# Cleanup Context Menus
reg import "$PSScriptRoot\..\\WindowsContextMenu\Removers\remove_GIT_BASH_CMD.reg" >$null 2>&1
reg import "$PSScriptRoot\..\\WindowsContextMenu\Removers\remove_VLC.reg" >$null 2>&1

# Remove unwanted objects
reg import "$PSScriptRoot\..\\WindowsNameSpaceFolders\Remove_3DObjects_Folder.reg" >$null 2>&1

Write-Host "Context menu adjustment completed..." -ForegroundColor green

Write-Host "Script completed." -ForegroundColor green