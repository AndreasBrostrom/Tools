if ( ($args[1] -eq "--copy") -or (-not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))) {
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

if ( $args[1] -eq "--copy" ) {
    if (Test-Path -Path $DestPathName -PathType Leaf) { Remove-Item $DestPathName }
    Copy-Item -Path "$TargetPathName" -Destination $Dest -Force >$null 2>&1
    Get-ChildItem "$TargetPathName" -Force
} else {
    New-Item -ItemType SymbolicLink -Target "$TargetPathName" -Path $DestPathName -Force >$null 2>&1   
    Get-ChildItem "$TargetPathName" -Force
}
