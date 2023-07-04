#Requires -RunAsAdministrator
Set-ExecutionPolicy Bypass -Scope Process -Force

if ("$Env:OS" -ne "Windows_NT") { Write-Host "Your not running on a Windows shell..." -ForegroundColor Red; exit }    
Import-Module Appx -usewindowspo

Set-ExecutionPolicy RemoteSigned -scope CurrentUser


# GLOBALS
$scoop_buckets    = 'extras'

$scoop_pkg        = 'sudo', 'git', 'aria2', '7zip',         # Required
                    'grep', 'ripgrep', 'sed', 'touch', 'jq', 'dos2unix', 'wget', 'findutils',
                    'zip', 'unzip',
                    'neovim', 'scrcpy',
                    'python', 'rust',
                    'gh',
                    'starship',
                    'steamcmd', 'android-sdk', 'rufus',
                    'ntop',                                 # htop-like system-monitor
                    'sharpkeys'                             # Key rebinding

$choco_pkg        = $null #'linux-reader'

$winget_pkg       = 'Google.Chrome',
                    'Microsoft.VisualStudioCode',
                    'Microsoft.Office',
                    'Discord.Discord', 'TeamSpeakSystems.TeamSpeakClient',
                    'Microsoft.PowerToys',
                    'Microsoft.PowerShell',
                    'VideoLAN.VLC', 'OBSProject.OBSStudio',
                    'TimKosse.FileZilla.Client',            # FTP Client
                    'DiskInternals.LinuxReader'             # EXT disk reader
                    'Valve.Steam --location "C:\Programs\Opt\Steam"'
                    #'Microsoft.WindowsTerminal'            # (Installed via store)
                    #'DebaucheeOpenSourceGroup.Barrier'     # Screen passover tool
                    #'ShiningLight.OpenSSL'                 # Needed by: Barrier
                    #'marha.VcXsrv'                         # xServer

$winget_rm_pkg    = $null #'Microsoft.GamingApp_8wekyb3d8bbwe',
                    #'Microsoft.WindowsMaps_8wekyb3d8bbwe',
                    #'Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe',
                    #'Microsoft.Xbox.TCUI_8wekyb3d8bbwe',
                    #'Microsoft.XboxGameOverlay_8wekyb3d8bbwe',
                    #'Microsoft.XboxGamingOverlay_8wekyb3d8bbwe',
                    #'Microsoft.XboxIdentityProvider_8wekyb3d8bbwe',
                    #'Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe',
                    #'Microsoft.Edge',
                    #'Microsoft.Edge.Update',
                    #'Microsoft.EdgeWebView2Runtime',
                    #'Microsoft.549981C3F5F10_8wekyb3d8bbwe',
                    #'Microsoft.BingNews_8wekyb3d8bbwe',
                    #'Microsoft.BingWeather_8wekyb3d8bbwe',
                    #'Microsoft.People_8wekyb3d8bbwe',
                    #'Microsoft.WindowsAlarms_8wekyb3d8bbwe',
                    #'Microsoft.Todos_8wekyb3d8bbwe',
                    #'Microsoft.YourPhone_8wekyb3d8bbwe',
                    #'Microsoft.ZuneMusic_8wekyb3d8bbwe',
                    #'Microsoft.ZuneVideo_8wekyb3d8bbwe'

$pwsh_modules     = 'PSWindowsUpdate'




# Script start
Write-Host "Starting up..." -ForegroundColor Magenta



# Setting up root enviroment
if ( -not Test-Path "C:\Programs" ) {
    New-Item -itemtype "directory" -path "C:\Programs" >$null 2>&1
    New-Item -itemtype Junction -path "$Env:userprofile" -name "Programs" -value "C:\Programs"
}

New-Item -itemtype "directory" -path "C:\Programs\Bin" >$null 2>&1
if ( ! $env:path.Contains(";C:\Programs\Bin")) { [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Programs\Bin", "Machine") }

New-Item -itemtype Junction -path "C:\" -name "bin" -value "C:\Programs\Bin" >$null 2>&1

New-Item -itemtype "directory" -path "C:\Programs\Opt" -Force >$null 2>&1
New-Item -itemtype "directory" -path "C:\Programs\Lib" -Force >$null 2>&1


Write-Host "Setting up symbolic links and directories..."
New-Item -itemtype Junction -path "C:\" -name "tmp" -value "$Env:temp" -Force >$null 2>&1
(get-item "C:\tmp\").Attributes += 'Hidden'

New-Item -itemtype "directory" -path "C:\Programs\Opt\Steam\steamapps\common" -Force >$null 2>&1
New-Item -itemtype Junction -path "C:\Programs\" -name "SteamApps" -value "C:\Programs\Opt\Steam\steamapps\common" -Force

New-Item -itemtype Junction -path "$Env:userprofile" -name ".Templates" -value "$env:appdata\Microsoft\Windows\Templates"  -Force
(get-item $Env:userprofile\.Templates).Attributes += 'Hidden'



# Installing scoop
Write-Host "Setting up Scoop..." -ForegroundColor Magenta
$env:SCOOP_GLOBAL="C:\Programs\Opt\scoop"
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')

if (![System.IO.File]::Exists("$env:USERPROFILE\scoop\shims\scoop")) {
    Write-Host "Installing Scoop..." -ForegroundColor Magenta
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') >$null 2>&1
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
        if (![System.IO.Directory]::Exists("$env:PROGRAMDATA\scoop\apps\$pkg")) {
            Write-Host "Installing $pkg..."
            scoop install $pkg --global >$null 2>&1
        } else {
            Write-Host "Scoop $pkg already installed skipping..." -ForegroundColor Yellow
        }
    }
    Write-Host "Installation of scoop packages completed..." -ForegroundColor Green
}


# Installing Chocolately
Write-Host "Setting up Chocolately..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("C:\ProgramData\chocolatey\choco.exe")) {
    Write-Host "Installing Chocolately..." -ForegroundColor green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Changeing and setting some paths for Chocolately..."
    choco feature enable -n allowGlobalConfirmation >$null 2>&1
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")
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



# Installing Winget
Write-Host "Setting up WinGet..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\winget.exe")) {
    Write-Host "Installing WinGet..." -ForegroundColor green

    Add-AppxPackage "https://aka.ms/getwinget" -InstallAllResources 

    Write-Host "Changeing and setting some paths for WinGet..."
} else { Write-Host "Chocolately already exist..." -ForegroundColor Yellow }

# Winget packages
Write-Host "Installing WinGet packages..."
foreach ($pkg in $winget_pkg) {
    Write-Host "Installing $pkg..."
    winget install --silent -e --id $pkg
}
Write-Host "Installation of WinGet packages completed..." -ForegroundColor Green


# Remove bloatware
if ($winget_rm_pkg) {
    Write-Host "Removing bloatware..."
    foreach ($pkg in $winget_rm_pkg) {
        Write-Host "Removing $pkg..."
        winget uninstall $pkg
    }
    Write-Host "Bloatware removal completed..." -ForegroundColor Green
}



# Install powershell moduels
Write-Host "Powershell modules..."
Set-PSRepository PSGallery
foreach ($module in $pwsh_modules) {
    Install-Module -Name $module -AllowClobber >$null 2>&1
}
Write-Host "Powershell module installation completed..." -ForegroundColor Green



# Download drives and packages for gaming
Write-Host "Downloading drives and programs for gaming..." -ForegroundColor Magenta
if (![System.IO.File]::Exists("$Env:userprofile\Downloads\TrackIR_5.4.2.exe")) {
    Invoke-WebRequest https://s3.amazonaws.com/naturalpoint/trackir/software/TrackIR_5.4.2.exe -OutFile "$Env:userprofile\Downloads\TrackIR_5.4.2.exe" >$null 2>&1
} else {
    Write-Host "TrackIR already downloaded skipping..." -ForegroundColor Yellow
}
if (![System.IO.File]::Exists("$Env:userprofile\Downloads\Setup.exe")) {
    Invoke-WebRequest https://api.roccat-neon.com/device/Support/Driver/Download/315/Tyon.zip -OutFile "$Env:userprofile\Downloads\Tyon.zip" >$null 2>&1
    Expand-Archive "$Env:userprofile\Downloads\Tyon.zip" -DestinationPath "$Env:userprofile\Downloads\" >$null 2>&1
    Remove-Item "$Env:userprofile\Downloads\Tyon.zip" >$null 2>&1
} else {
    Write-Host "ROCCAT Tyon already downloaded skipping..." -ForegroundColor Yellow
}
Write-Host "Drives packages downloaded and ready..." -ForegroundColor Green



Write-Host "Applying windows features..." -ForegroundColor Magenta

# WSL
Write-Host "Setting up WSL" -ForegroundColor green
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl.exe --set-default-version 2


# SSH
Write-Host "Setting up open ssh" -ForegroundColor green
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Default shell to pwsh
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $((Get-Command pwsh.exe).source) -PropertyType String -Force

# Startup
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
Write-Host "Windows features and ssh setup..." -ForegroundColor Green



# Setting up home
Write-Host "Setting up home..."
New-Item -itemtype "directory" -path "$Env:userprofile\.bin" -Force
(get-item $Env:userprofile\.bin).Attributes += 'Hidden'
if ( ! $env:path.Contains(";$Env:userprofile\.bin")) { [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Env:userprofile\.bin", "User") }

New-Item -itemtype "directory" -path "$Env:userprofile\.config"
(get-item $Env:userprofile\.config).Attributes += 'Hidden'



# Setup powershell profile
if (![System.IO.File]::Exists("$Env:userprofile\Documents\PowerShell\profile.ps1")) {
    Write-Host "Configurating Powershell..." -ForegroundColor Magenta
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\PowerShell\"
    (get-item $Env:userprofile\Documents\PowerShell).Attributes += 'Hidden'
    New-Item -itemtype "directory" -path "$Env:userprofile\Documents\WindowsPowerShell\"
    (get-item $Env:userprofile\Documents\WindowsPowerShell).Attributes += 'Hidden'
    
    "if (Test-Path `"$env:userprofile\.pwshrc.ps1`" -PathType leaf) {`n    . `"$env:userprofile\.pwshrc.ps1`"`n}" | Out-File -FilePath "$Env:userprofile\Documents\PowerShell\profile.ps1"

    Write-Host "Restoring powershell profile..."
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwshrc.ps1" -Destination "$Env:userprofile"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwsh_path.ps1" -Destination "$Env:userprofile"
    Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\Home\.pwsh_aliases.ps1" -Destination "$Env:userprofile"
    (get-item $Env:userprofile\.pwshrc.ps1).Attributes += 'Hidden'
    (get-item $Env:userprofile\.pwsh_path.ps1).Attributes += 'Hidden'
    (get-item $Env:userprofile\.pwsh_aliases.ps1).Attributes += 'Hidden'

    New-Item -itemtype SymbolicLink -path "$Env:userprofile\Documents\WindowsPowerShell" -name "profile.ps1" -value "$Env:userprofile\Documents\PowerShell\profile.ps1"
    Write-Host "Configuration of PowerShell complete..." -ForegroundColor Green
} else {
    Write-Host "Powershell already configured skipping..." -ForegroundColor Yellow
}



# Creating quick links for terminal
Write-Host "Setting up Programs and Terminal shims..." -ForegroundColor Magenta

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ProgramData\Chocolatey\tools", "Machine")

#C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\choco.exe" -p="C:\ProgramData\Chocolatey\choco.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\chrome.exe" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\google-chrome-stable.exe" -p="C:\Program Files\Google\Chrome\Application\chrome.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\steam.exe" -p="C:\Program Files (x86)\Steam\Steam.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\pwsh.exe" -p="C:\Program Files\PowerShell\7\pwsh.exe" >$null 2>&1
C:\ProgramData\Chocolatey\tools\shimgen.exe -o="C:\Programs\Bin\shimgen.exe" -p="C:\ProgramData\Chocolatey\tools\shimgen.exe" >$null 2>&1

"Start-Process -FilePath `"$env:userprofile\AppData\Local\Discord\Update.exe`" -ArgumentList `"--processStart Discord.exe`"" | Out-File -FilePath "C:\Programs\Bin\discord.ps1"
"Start-Process -FilePath `"C:\Program Files (x86)\Steam\Steam.exe`" -ArgumentList `"steam://rungameid/107410`""  | Out-File -FilePath "C:\Programs\Bin\arma.ps1"
"Start-Process -FilePath `"C:\Program Files (x86)\Steam\Steam.exe`" -ArgumentList `"steam://rungameid/281990`""  | Out-File -FilePath "C:\Programs\Bin\stellaris.ps1"
"Start-Process -FilePath `"C:\Program Files (x86)\Steam\Steam.exe`" -ArgumentList `"steam://rungameid/394360`""  | Out-File -FilePath "C:\Programs\Bin\hoi4.ps1"
"Start-Process -FilePath `"C:\Program Files (x86)\Steam\Steam.exe`" -ArgumentList `"steam://rungameid/1142710`"" | Out-File -FilePath "C:\Programs\Bin\warhammer.ps1"
"Start-Process -FilePath `"C:\Program Files (x86)\Steam\Steam.exe`" -ArgumentList `"steam://rungameid/1611600`"" | Out-File -FilePath "C:\Programs\Bin\warno.ps1"

Write-Host "Programs and Terminal shims created..." -ForegroundColor green



# Autostart
Write-Host "Setting up autostart..." -ForegroundColor Magenta
$autostart=[Environment]::GetFolderPath('CommonStartup')
New-Item -itemtype Junction -path "C:\Programs" -name "Startup" -value "$autostart"
#Copy-Item "$PSScriptRoot\..\MyLibrary\Windows\VcXSrv\config.xlaunch" -Destination "C:\Programs\Startup\"

# Change windows time (dualboot)
Write-Host "Adjusting the clock..." -ForegroundColor Magenta
C:\Windows\System32\reg.exe import "$PSScriptRoot\..\WindowsUTCTime\Make Windows Use UTC Time.reg" >$null 2>&1
Write-Host "Clock adjustment completed..." -ForegroundColor green



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



# Setup Keyboard and languishes
#Write-Host "Setting up languages..." -ForegroundColor Magenta

#$LanguageList = Get-WinUserLanguageList 
#$LanguageList.Add("en-GB") Set-WinUserLanguageList 
#$LanguageList.Add("sv-SE") Set-WinUserLanguageList 
#Set-WinUserLanguageList en-GB -Force

#Write-Host "Language completed..." -ForegroundColor green


if (Test-Path D: )


Write-Host "Script completed." -ForegroundColor green
