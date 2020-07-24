
$armaRptPath="$env:USERPROFILE\AppData\Local\Arma 3"
$program="$($MyInvocation.MyCommand.Name.Replace('.ps1', ''))"
function help() {
    Write-Host "$program

Usage:
    $program rpt [-c] [-w]
    $program p [--set <path>] [--mount] [--umount]
    $program (-h | --help)

Commands:
    rpt     RPT log handeling
    p       P-Drive handeling

Options:
    rpt -c, --clear                 clear all arma 3 rpt logs
    rpt -w, --watch < | filter>     watch latest created RPT log
    p --set <PATH>                  set the path of the P-Drive
                                    note: You can set this to any path allowing
                                    multiply P-Drive locations
    p --mount                       mount the P-Drive using the set path
    p --umount                      unmount the P-Drive
    -h, --help                      show this help"
    exit 0
}

function rpt() {
    if ( $args[0] -eq '--clear' -or $args[0] -eq '-c' ) {
        Write-Host "Clearing RPT logs"
        Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt | Remove-Item
        Write-Host "Done"
        exit 0
    }

    if ( $args[0] -eq '--watch' -or $args[0] -eq '-w' ) {
        $latestLog = $(Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt | sort LastWriteTime | select -last 1)
        if ( ![System.IO.File]::Exists($latestLog) ) {
            Write-Host "No logfiles are avalible to watch"
            exit 1
        }
        Write-Host "Starting watch of latest RPT log file"
        tail $latestLog $args[0]
        exit 0
    }

    Set-Location -Path "$armaRptPath"
    $logs = @(Get-ChildItem -Path "$armaRptPath\*" -Include *.rpt)
    if ( $logs.length -eq 0 ) {
        Write-Host "There are currently no RPT logs"
        exit 0
    }
    Write-Host "Avalible RPT logs:"
    Write-Host "$logs.name"
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
    if ( $args[0] -eq '--mount' ) {
        #& "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\WorkDrive\WorkDrive.exe" /Mount $pdrivePath
        Start-Process -NoNewWindow -FilePath "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\WorkDrive\WorkDrive.exe" -ArgumentList "/Mount", "P" , $pdrivePath
        exit 0
    }
    if ( $args[0] -eq '--umount' ) {
        Start-Process -NoNewWindow -FilePath "C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\WorkDrive\WorkDrive.exe" -ArgumentList "/Dismount"
        exit 0
    }

    # defult behaviour
    if ( Test-Path -Path "P:" ) {
        Set-Location -Path $pdrivePath
        exit 0
    } else {
        Write-Host "Arma 3 P: drive is not mounted pleace mount it and try again."
        exit 1
    }
}

if ( $args[0] -eq '--help' -or $args[0] -eq '-h' ) { help }
if ( $args[0] -eq 'rpt' ) { rpt $args[1] }
if ( $args[0] -eq 'p' ) { p $args[1] $args[2] }

if ( $args ) {
    Write-Host "'$args' is not a supported parameter"
    exit 1
} else {
    Write-Host "$program
    
Usage:
    armadev rpt [-c] [-w]
    armadev p [--set <path>] [--mount] [--umount]
    armadev (-h | --help)"
}
