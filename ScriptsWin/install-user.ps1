function checkIfAdmin {
    if ( -not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
        Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.ScriptName)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline
        
        # check if have sudo programs installed
        $sudoScripts =  "$env:USERPROFILE\scoop\shims\sudo",
                        "$env:USERPROFILE\scoop\shims\sudo.ps1",
                        "$env:PROGRAMDATA\scoop\shims\sudo",
                        "$env:PROGRAMDATA\scoop\shims\sudo.ps1",
                        "$env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                        "$env:USERPROFILE\.bin\sudo.ps1",
                        "$env:SCOOP_GLOBAL\shims\sudo",
                        "$env:SCOOP_GLOBAL\shims\sudo.ps1"
        
        foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
        if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
        
        Write-Host ", and then running the script again." -ForegroundColor Red
        exit 1
    }
}

if ( -Not $IsWindows ) {
    Write-host "This script does not work on none-windows system" -ForegroundColor Red
    exit 1
}


if ( $args.count -eq 0 ) {
    Write-Host "Usage: install-allusers TARGET"
    Write-Host "       install-allusers TARGET ALIAS"
    Write-Host "       install-allusers TARGET --copy"
    exit 0
}


# Arguments
$copy = $False
foreach ($arg in $args) {
    if ($arg -in @("--copy")) {
        $copy = $True
        continue
    }
}

$TargetName     = $args[0]
$TargetPathName = Get-Item -LiteralPath $TargetName | % { $_.FullName }
$Dest           = "$env:userprofile/.bin"
$DestPathName   = if ( $args.count -eq 3 ) { Join-Path $Dest $args[1] } else { Join-Path $Dest $TargetName }

if ( $args[1] -eq "--copy" ) {
    if (Test-Path -Path $DestPathName -PathType Leaf) { Remove-Item $DestPathName }
    Copy-Item -Path "$TargetPathName" -Destination $Dest -Force >$null 2>&1

    if (Test-Path -Path $DestPathName -PathType Leaf) {
        Write-host "Copied: $DestPathName -> $TargetPathName" -ForegroundColor white
    } else {
        Write-host "ERROR: Copy of file $DestPathName -> $TargetPathName could not be done" -ForegroundColor red; exit 1
    }
} else {
    checkIfAdmin
    if (Test-Path -Path $DestPathName -PathType Leaf) { Remove-Item $DestPathName }
    New-Item -ItemType SymbolicLink -Target "$TargetPathName" -Path $DestPathName -Force >$null 2>&1   

    if (Test-Path -Path $DestPathName -PathType Leaf) {
        Write-host "SymbolicLink created: $DestPathName -> $TargetPathName" -ForegroundColor white
    } else {
        Write-host "ERROR: SymbolicLink for $DestPathName -> $TargetPathName could not be created" -ForegroundColor red; exit 1
    }
}
