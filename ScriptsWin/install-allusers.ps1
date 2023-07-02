if ( -not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
    Write-Host "$([io.path]::GetFileNameWithoutExtension("$($MyInvocation.MyCommand.Name)")) is not running as Administrator. Start PowerShell by using the Run as Administrator option" -ForegroundColor Red -NoNewline

    # check if have sudo programs installed
    $sudoScripts =  "$env:USERPROFILE\scoop\shims\sudo",
                    "$env:USERPROFILE\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\scoop\shims\sudo",
                    "$env:PROGRAMDATA\scoop\shims\sudo.ps1",
                    "$env:PROGRAMDATA\chocolatey\bin\Sudo.exe",
                    "$env:USERPROFILE\.bin\sudo.ps1"

    foreach ($sudoScript in $sudoScripts) { if ( [System.IO.File]::Exists("$sudoScript") ) { [bool] $hasSudo = 1; break } }
    if ($hasSudo) { Write-Host " or run with sudo" -ForegroundColor Red -NoNewline }
    
    Write-Host ", and then running the script again." -ForegroundColor Red
    exit 1
}

if ( -Not $IsWindows ) {
    Write-host "This script does not work on none-windows system" -ForegroundColor Red
    exit 1
}

$TargetName     = $args[0]
$TargetPathName = Get-Item -LiteralPath $TargetName | % { $_.FullName }
$Dest           = "C:\bin"
$DestPathName   = Join-Path $Dest $TargetName

if ( $args[1] -eq "--shim" ) {
    if (Test-Path -Path $DestPathName -PathType Leaf) { Remove-Item $DestPathName }
    shimgen -o $DestPathName -p $TargetPathName >$null 2>&1
    if (Test-Path -Path $DestPathName -PathType Leaf) {
        Write-host "Shim created: $TargetPathName -> $DestPathName" -ForegroundColor white
        #Get-ChildItem "$TargetPathName" -Force
    } else {
        Write-host "ERROR: Shim for $TargetPathName -> $DestPathName could not be created" -ForegroundColor red
    }
} else {
    if (Test-Path -Path $DestPathName -PathType Leaf) { Remove-Item $DestPathName }
    New-Item -ItemType SymbolicLink -Target "$TargetPathName" -Path $DestPathName -Force >$null 2>&1   
    if (Test-Path -Path $DestPathName -PathType Leaf) {
        Write-host "SymbolicLink created: $DestPathName -> $TargetPathName" -ForegroundColor white
        #Get-ChildItem "$TargetPathName" -Force
    } else {
        Write-host "ERROR: SymbolicLink for $DestPathName -> $TargetPathName could not be created" -ForegroundColor red
    }
}
