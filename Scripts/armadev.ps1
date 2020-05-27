
$armaRptPath="$env:USERPROFILE\AppData\Local\Arma 3"
$program="$($MyInvocation.MyCommand.Name.Replace('.ps1', ''))"

function help() {
    Write-Host "$program"
        "`nUsage:"
        "    $program rpt [-c] [-w]"
        "    $program p [--set <path>] [--mount] [--umount]"
        "    $program tools"
        "    $program (-h | --help)"

        "`nCommands:"
        "    rpt     RPT log handeling"
        "    p       P-Drive handeling"
        "    tools   Show avalible Arma 3 Tools"

        "`nOptions:"
        "    rpt -c, --clear                 clear all arma 3 rpt logs"
        "    rpt -w, --watch < | filter>     watch latest created RPT log"
        "    p --set <PATH>                  set the path of the P-Drive"
        "                                    note: You can set this to any path allowing"
        "                                    multiply P-Drive locations"
        "    p --mount                       mount the P-Drive using the set path"
        "    p --umount                      unmount the P-Drive"
        "    -h, --help                      show this help"
    exit 0
}

function tools() {
    function Test-Tools() { Get-Command $args[0] -errorAction SilentlyContinue }

    Write-Host "Discoverd tools:"
    $regpath="Registry::HKEY_CURRENT_USER\SOFTWARE\Bohemia Interactive\Arma 3 Tools"
    if ( Get-ItemPropertyValue $regpath -Name path -errorAction SilentlyContinue ) { Write-Host " > Arma 3 Tools $(Get-ItemPropertyValue $regpath -Name version -errorAction SilentlyContinue)"}
    if ( Test-Tools armake ) { Write-Host " > armake $(armake --version)"}
    if ( Test-Tools armake2 ) { Write-Host " > armake2 $(armake2 --version)"}
    if ( Test-Tools hemtt ) { Write-Host " > $(hemtt --version)"}
    $regpath="Registry::HKEY_CURRENT_USER\SOFTWARE\Mikero"
    $mikeroTools=$(Get-ChildItem $regpath -Name)
    ForEach ( $tool in $mikeroTools ) {
        Write-Host " > Mikero $tool"
    }
    exit 0
}

function rpt() {
    #Check avalible logs
    $logs = @(Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt)
    
    if ( $args[0] -eq '--clear' -or $args[0] -eq '-c' ) {
        if ( $logs.length -eq 0 ) { Write-Host "No RPT logs to clear"; exit 0 }
        Write-Host "Clearing RPT logs..." -confirm
        Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt | Remove-Item
        Write-Host "All rpt logs have been removed."
        exit 0
    }

    if ( $args[0] -eq '--watch' -or $args[0] -eq '-w' ) {
        $latestLog = $(Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt | sort LastWriteTime | select -last 1)
        if ( ![System.IO.File]::Exists($latestLog) ) {
            Write-Host "No logfiles are avalible to watch"
            exit 1
        }
        Write-Host "Starting watch of latest RPT log file: $($latestLog.name)"
        if ( $latestLog -and -not $args[0] ) {
            Get-Content $latestLog -wait -tail $($Host.UI.RawUI.WindowSize.Height-2)
        } else {
            Get-Content $latestLog -wait -tail $($Host.UI.RawUI.WindowSize.Height-2) | Select-String -NoEmphasis -Patter $args[0]
        }
        exit 0
    }

    Set-Location -Path "$armaRptPath"
    if ( $logs.length -eq 0 ) { Write-Host "There are currently no RPT logs" -ForegroundColor DarkGray; exit 0 }
    Write-Host "Avalible RPT logs ($($logs.count)):"
    $logs.name | ForEach-Object { Write-Host " > $_" -ForegroundColor DarkGray }

    exit 0
}

function p() {
    # Check P-drive path
    if ( $args[0] -eq '--set' ) {
        if ( -not $args[1] ) { Write-Host "No valid path to your P-Drive location given"; exit 1 }
        if ( -not $(Test-Path $args[1]) ) { Write-Host "Your path '$($args[1])' does not exist"; exit 1 }
        if ( -not $(Test-Path -Path "$env:USERPROFILE\.config\armadev\") ) { New-Item -ItemType "directory" -Path "$env:USERPROFILE\.config\armadev\" >$null 2>&1 }
        Set-Content "$env:USERPROFILE\.config\armadev\armap" $args[1] >$null 2>&1
        exit 0
    }
    if ( -not $(Test-Path "$env:USERPROFILE\.config\armadev\armap") ) {
        Write-Host "Path to P-Drive is not defined please run '--set [PATH]' to set path"
        exit 1
    }
    $pdrivePath=$(Get-Content "$env:USERPROFILE\.config\armadev\armap").trim('\')
    if ( -not $(Test-Path "$pdrivePath") ) { Write-Host "Given path '$pdrivePath' is not valid"; exit 1 }

    # mount and unmount
    $regpath="Registry::HKEY_CURRENT_USER\SOFTWARE\Bohemia Interactive\Arma 3 Tools"
    $mountToolPath=if ( Get-ItemPropertyValue $regpath -Name path -errorAction SilentlyContinue ) { $(Get-ItemPropertyValue $regpath -Name path -errorAction SilentlyContinue) }
    $mountTool= Join-Path $mountToolPath -ChildPath "WorkDrive\WorkDrive.exe"
    if ( $args[0] -eq '--mount' ) {
        if ( Test-Path -Path "P:" ) { Write-Host "P-Drive already mounted"; exit 1 }
        Start-Process -FilePath $mountTool -ArgumentList "/Mount", "P" , $pdrivePath
        exit 0
    }
    if ( $args[0] -eq '--umount' ) {
        if ( -not $(Test-Path -Path "P:") ) { Write-Host "P-Drive not mounted"; exit 1 }
        Start-Process -FilePath $mountTool -ArgumentList "/Dismount"
        exit 0
    }

    # defult behaviour
    if ( -not $(Test-Path -Path "P:") ) {
        Write-Host "Warning: Arma 3 P-drive is not mounted" -ForegroundColor Yellow
    }
    Set-Location -Path $pdrivePath
    exit 0
}

if ( $args[0] -eq '--help' -or $args[0] -eq '-h' ) { help }
if ( $args[0] -eq 'tools' ) { tools $args[1] }
if ( $args[0] -eq 'rpt' ) { rpt $args[1] }
if ( $args[0] -eq 'p' ) { p $args[1] $args[2] }

if ( $args ) {
    Write-Host "'$args' is not a supported parameter"
    exit 1
} else {
    Write-Host "$program"
        "`nUsage:"
        "    $program rpt [-c] [-w]"
        "    $program p [--set <path>] [--mount] [--umount]"
        "    $program tools"
        "    $program (-h | --help)"
}
