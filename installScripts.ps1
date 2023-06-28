#!/bin/pwsh

if ( -Not $IsWindows ) {
    Write-host "This script does not work on non windows system"
    exit 1
}
$desitnation = if ($args[0] -eq "-user") { "$($env:USERPROFILE)\.bin" } else { "C:\bin"}
    

Write-host "Copying scripts to $desitnation\."

ForEach ($filePath in Get-ChildItem "ScriptsWin") {
    #Write-host "$($filePath.name) -> $desitnation\$($filePath.name)" 
    $path = "$($desitnation)\$($filePath.name)"
    New-Item -ItemType SymbolicLink -Target "$filePath" -Path $path -Force
}
