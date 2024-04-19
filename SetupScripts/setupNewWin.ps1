#Requires -RunAsAdministrator
Set-ExecutionPolicy Bypass -Scope Process -Force

if ("$Env:OS" -ne "Windows_NT") { Write-Host "Your not running on a Windows shell..." -ForegroundColor Red; exit }    

Set-ExecutionPolicy RemoteSigned -scope CurrentUser


# GLOBALS
$use_scoop      = $true
$use_winget     = $true
$use_choco      = $false

$scoop_buckets  = 'extras'

$scoop_pkg      = 'sudo', 'git', 'aria2', '7zip', # Required
                  'git', 'gh', 'act'
                  'zip', 'unzip',
                  'grep', 'ripgrep', 'sed', 'touch', 'jq', 'dos2unix', 'wget', 'findutils',
                  'neovim', 'scrcpy', 'helix',
                  'python', 'nodejs', 'rust',
                  'starship',
                  'steamcmd', 'android-sdk', 'rufus',
                  'ntop',                                 # htop-like system-monitor
                  'sharpkeys'                             # Key rebinding

$winget_pkg     = 'Google.Chrome',
                  'Microsoft.OpenSSH.Beta'
                  'Microsoft.VisualStudioCode',
                  'Discord.Discord',
                  'TeamSpeakSystems.TeamSpeakClient',
                  'Microsoft.PowerToys',
                  'Microsoft.PowerShell',
                  'VideoLAN.VLC',
                  'OBSProject.OBSStudio',
                  'Valve.Steam --location "C:\Programs\Opt\Steam"',
                  'qBittorrent.qBittorrent',
                  '9MZNMNKSM73X',                         # [WinStore] WSL: Arch
                  '9MZ1SNWT0N5D',                         # [WinStore] Windows PowerShell Core
                  '9p8ltpgcbzxd',                         # [WinStore] Wintoys
                  'xp89dcgq3k6vld'                        # [WinStore] Microsoft PowerToys
                  #'DebaucheeOpenSourceGroup.Barrier'     # Screen passover tool
                  #'ShiningLight.OpenSSL'                 # Needed by: Barrier
                  #'DiskInternals.LinuxReader',           # EXT disk reader
                  #'marha.VcXsrv'                         # xServer

$winget_rm_pkg  = 'Microsoft.People_8wekyb3d8bbwe',
                  'Microsoft.BingNews_8wekyb3d8bbwe',
                  'Microsoft.BingWeather_8wekyb3d8bbwe',
                  'Microsoft.Todos_8wekyb3d8bbwe',
                  'Microsoft.WindowsAlarms_8wekyb3d8bbwe',
                  'Microsoft.WindowsMaps_8wekyb3d8bbwe',
                  'Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe',
                  'Microsoft.YourPhone_8wekyb3d8bbwe',
                  'Microsoft.ZuneMusic_8wekyb3d8bbwe',
                  'Microsoft.ZuneVideo_8wekyb3d8bbwe'
                  #'Microsoft.GamingApp_8wekyb3d8bbwe',
                  #'Microsoft.Xbox.TCUI_8wekyb3d8bbwe',
                  #'Microsoft.XboxGameOverlay_8wekyb3d8bbwe',
                  #'Microsoft.XboxGamingOverlay_8wekyb3d8bbwe',
                  #'Microsoft.XboxIdentityProvider_8wekyb3d8bbwe',
                  #'Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe'

$choco_pkg      = $null #'linux-reader'

$pwsh_modules   = 'PSWindowsUpdate'


# Script start
Write-Host "Starting up..." -ForegroundColor Magenta

#
# Setting up linux like root enviroment
#
if ( -not Test-Path "C:\Programs" ) {
    New-Item -itemtype "directory" -path "C:\Programs" -Force >$null 2>&1
}

New-Item -itemtype "directory" -path "C:\Programs\Bin" -Force >$null 2>&1
if ( ! $Env:path.Contains(";C:\Programs\Bin")) { [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";C:\Programs\Bin", "Machine") }

New-Item -itemtype Junction -path "C:\" -name "bin" -value "C:\Programs\Bin" >$null 2>&1

New-Item -itemtype "directory" -path "C:\Programs\Opt" -Force >$null 2>&1
New-Item -itemtype "directory" -path "C:\Programs\Lib" -Force >$null 2>&1

Write-Host "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "tmp" -value "$Env:temp" -Force >$null 2>&1
(get-item "C:\tmp\").Attributes += 'Hidden'

New-Item -itemtype "directory" -path "C:\Programs\Opt\Steam\steamapps\common" -Force >$null 2>&1
New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Programs\Opt\Steam\steamapps\common" -Force

New-Item -itemtype Junction -path "$Env:USERPROFILE" -name ".Templates" -value "$Env:appdata\Microsoft\Windows\Templates"  -Force
(get-item $Env:USERPROFILE\.Templates).Attributes += 'Hidden'



#
# Scoop
#
if ($use_scoop) {
    Write-Host "Setting up Scoop..." -ForegroundColor Magenta
    
    # Set global install directory
    $Env:SCOOP_GLOBAL="C:\Programs\Opt\scoop"
    [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $Env:SCOOP_GLOBAL, 'Machine')

    # Install Scoop
    if (![System.IO.File]::Exists("$Env:USERPROFILE\scoop\shims\scoop")) {
        Write-Host "Installing Scoop..." -ForegroundColor Magenta
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    } else {
        Write-Host "Scoop already exist no need to install. Checking for updates..." -ForegroundColor Yellow
        scoop update scoop >$null 2>&1
    }

    if ($scoop_buckets) {
        Write-Host "Adding Scoop buckets..."
        foreach ($buckets in $scoop_buckets) {
            scoop bucket add $buckets >$null 2>&1
        }
        Write-Host "Updating repos..."
    }
    scoop update * >$null 2>&1

    # Install scoop packages
    if ($scoop_pkg) {
        Write-Host "Installing Scoop packages..."
        foreach ($pkg in $scoop_pkg) {
            if (![System.IO.Directory]::Exists("$Env:PROGRAMDATA\scoop\apps\$pkg")) {
                Write-Host "Installing $pkg..."
                scoop install $pkg --global >$null 2>&1
            } else {
                Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
            }
        }
        Write-Host "Installation of scoop packages completed..." -ForegroundColor Green
    }
}



#
# Chocolately
#
if ($use_choco) {
    Write-Host "Setting up Chocolately..." -ForegroundColor Magenta

    # Install Chocolately
    if (![System.IO.File]::Exists("C:\ProgramData\chocolatey\choco.exe")) {
        Write-Host "Installing Chocolately..." -ForegroundColor green
        Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Host "Changeing and setting some paths for Chocolately..."
        choco feature enable -n allowGlobalConfirmation >$null 2>&1
        [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")
    } else { Write-Host "Chocolately already exist..." -ForegroundColor Yellow }

    # Chocolately packages
    if ($choco_pkg) {
        Write-Host "Installing Chocolately packages..."
        $chocoInstalledPackages=choco list --localonly

        foreach ($pkg in $choco_pkg) {
            if (!($chocoInstalledPackages -like "*$pkg*")) {
                Write-Host "Installing $pkg..."
                choco install $pkg -y >$null 2>&1
            } else {
                Write-Host "Choco $pkg already installed skipping..." -ForegroundColor Yellow
            }
        }
        Write-Host "Installation of chocolately packages completed..." -ForegroundColor Green
    }
}



#
# Winget
#
if (use_winget) {
    # Install Winget
    Write-Host "Setting up WinGet..." -ForegroundColor Magenta
    if (![System.IO.File]::Exists("$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\winget.exe")) {
        Write-Host "Installing WinGet..." -ForegroundColor green
        Add-AppxPackage "https://aka.ms/getwinget" -InstallAllResources 
    } else { Write-Host "WinGet already exist..." -ForegroundColor Yellow }

    # Winget packages
    if ($winget_pkg) {
        Write-Host "Installing WinGet packages..."
        foreach ($pkg in $winget_pkg) {
            Write-Host "Installing $pkg..."
            winget install --silent -e --id $pkg
        }
        Write-Host "Installation of WinGet packages completed..." -ForegroundColor Green
    }

    # Remove bloatware
    if ($winget_rm_pkg) {
        Write-Host "Removing bloatware..."
        foreach ($pkg in $winget_rm_pkg) {
            Write-Host "Removing $pkg..."
            winget uninstall $pkg
        }
        Write-Host "Bloatware removal completed..." -ForegroundColor Green
    }
}



#
# Install powershell moduels
#
Write-Host "Powershell modules..."
Set-PSRepository PSGallery
foreach ($module in $pwsh_modules) {
    Install-Module -Name $module -AllowClobber >$null 2>&1
}
Write-Host "Powershell module installation completed..." -ForegroundColor Green


# Windows features
Write-Host "Applying windows features..." -ForegroundColor Magenta

#
# WSL
#
Write-Host "Setting up WSL" -ForegroundColor green
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl.exe --set-default-version 2

#
# SSH
#
Write-Host "Setting up Open SSH server and client" -ForegroundColor green
#Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
#
#Write-Host "OpenSSH Server may take a while..." -ForegroundColor Gray
#Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Default shell to pwsh
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $((Get-Command pwsh.exe).source) -PropertyType String -Force

# SSHD Startup
if (Test-Path "D:") {
    if (Test-Path "D:\secure") {
        Copy-Item "D:\secure\ProgramData\ssh\" -Destination "C:\ProgramData\ssh\" -Recurse -force
        Start-Service sshd
        Set-Service -Name sshd -StartupType 'Automatic'
    } else {
        Start-Service sshd
        Set-Service -Name sshd -StartupType 'Automatic' 
    }
} else {
    Start-Service sshd
    Set-Service -Name sshd -StartupType 'Automatic'
}

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
Write-Host "Windows features and ssh setup..." -ForegroundColor Green



#
# Setting up home
#
Write-Host "Setting up home..."
New-Item -itemtype "directory" -path "$Env:USERPROFILE\.bin" -Force
(get-item $Env:USERPROFILE\.bin).Attributes += 'Hidden'
if ( ! $Env:path.Contains(";$Env:USERPROFILE\.bin")) { [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";$Env:USERPROFILE\.bin", "User") }

New-Item -itemtype "directory" -path "$Env:USERPROFILE\.config"
(get-item $Env:USERPROFILE\.config).Attributes += 'Hidden'


# Autostart
Write-Host "Setting up autostart..." -ForegroundColor Magenta
$autostart=[Environment]::GetFolderPath('CommonStartup')
New-Item -itemtype Junction -path "C:\Programs" -name "Startup" -value "$autostart"
#Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\VcXSrv\config.xlaunch" -Destination "C:\Programs\Startup\"



# Setup Keyboard and languishes
#Write-Host "Setting up languages..." -ForegroundColor Magenta

#$LanguageList = Get-WinUserLanguageList 
#$LanguageList.Add("en-GB") Set-WinUserLanguageList 
#$LanguageList.Add("sv-SE") Set-WinUserLanguageList 
#Set-WinUserLanguageList en-GB -Force

#Write-Host "Language completed..." -ForegroundColor green



# Change windows time (dualboot)
#Write-Host "Adjusting the clock..." -ForegroundColor Magenta
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsUTCTime\Make Windows Use UTC Time.reg" >$null 2>&1
#Write-Host "Clock adjustment completed..." -ForegroundColor green



Write-Host "Adjusting the context menu..." -ForegroundColor Magenta
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\VSCode\Elevation_Add.reg" >$null 2>&1

#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\!cleanUnwantedCreateNewFile.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewCppFile.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewHppFile.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewMdFile.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewPythonFile.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsCustomNewFileRegFile\addCreateNewSqfFile.reg" >$null 2>&1

# Cleanup Context Menus
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_GIT_BASH_CMD.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_VLC.reg" >$null 2>&1
#C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsContextMenu\Removers\remove_VS.reg" >$null 2>&1

# Restoring save files from programs
Write-Host "Setting keybindings..." -ForegroundColor Magenta
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\KeyBinding\RebindCaps2Esc.reg" >$null 2>&1

Write-Host "Context menu adjustment completed..." -ForegroundColor green



# Setup powershell profile
if (![System.IO.File]::Exists("$Env:USERPROFILE\.config\PowerShell\config.ps1")) {
    Write-Host "Configurating Powershell..." -ForegroundColor Magenta
    New-Item -itemtype "directory" -path "$Env:USERPROFILE\Documents\PowerShell\"
    (get-item $Env:USERPROFILE\Documents\PowerShell).Attributes += 'Hidden'
    New-Item -itemtype "directory" -path "$Env:USERPROFILE\Documents\WindowsPowerShell\"
    (get-item $Env:USERPROFILE\Documents\WindowsPowerShell).Attributes += 'Hidden'

    New-Item -itemtype "directory" -path "$Env:USERPROFILE/.config/powershell/conf.d/"
    New-Item -itemtype "directory" -path "$Env:USERPROFILE/.config/powershell/functions/"

    Write-Host "Configuration of PowerShell complete..." -ForegroundColor Green
} else {
    Write-Host "Powershell already configured skipping..." -ForegroundColor Yellow
}



# Cehck for development drive
if (Test-Path "D:") {
    # Install dotfiles
    if (Test-Path "D:\wdotfiles") {
        Write-Host "Setting up dotfiles..." -ForegroundColor Magenta
        . D:\wdotfiles\install.ps1
        Write-Host "Setup of dotfiles complete..." -ForegroundColor Green
    }
    if (Test-Path "D:\secure") {
        New-Item -itemtype "directory" -path "$Env:USERPROFILE\.ssh"
        (get-item $Env:USERPROFILE\.ssh).Attributes += 'Hidden'
        Copy-Item "D:\secure\ssh\" -Destination "C:\ProgramData\ssh\" -Recurse -force

    }
}



# Download drives and packages for gaming
Write-Host "Downloading drives and programs for gaming..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("$Env:USERPROFILE\Downloads\TrackIR_5.4.2.exe")) {
    Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:USERPROFILE\Downloads\TrackIR_5.4.2.exe" >$null 2>&1
} else {
    Write-Host "TrackIR already downloaded skipping..." -ForegroundColor Yellow
}
if (![System.IO.File]::Exists("$Env:USERPROFILE\Downloads\Setup.exe")) {
    Invoke-WebRequest https://api.roccat-neon.com/device/Support/Driver/Download/315/Tyon.zip -OutFile "$Env:USERPROFILE\Downloads\Tyon.zip" >$null 2>&1
    Expand-Archive "$Env:USERPROFILE\Downloads\Tyon.zip" -DestinationPath "$Env:USERPROFILE\Downloads\" >$null 2>&1
    Remove-Item "$Env:USERPROFILE\Downloads\Tyon.zip" >$null 2>&1
} else {
    Write-Host "ROCCAT Tyon already downloaded skipping..." -ForegroundColor Yellow
}
Write-Host "Drives packages downloaded and ready..." -ForegroundColor Green




Write-Host "Script completed." -ForegroundColor green
