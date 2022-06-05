#!/bin/pwsh

$SCRIPT_DIR = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('./')

Set-Location "$SCRIPT_DIR"
Write-Host "Installing $((Get-Item $SCRIPT_DIR).Name)..." -ForegroundColor "DarkBlue"
 

Write-Host "Linking up home" -ForegroundColor "Yellow"
Set-Location "$SCRIPT_DIR/Home"
Get-ChildItem -Force -Directory -Recurse| Foreach-Object {
    $DirPath = $_.FullName | Resolve-Path -Relative
    $DirBasename = $_.BaseName
    if ( $IsLinux ) { # used to block sertain configs in linux assuming .files allready exist.
        if ( $DirPath.Contains('AppData') )       { return } # continue used for Foreach-Object
    }
    Write-Host " Creating $DirPath in directory..." -ForegroundColor "DarkGray"
    New-Item -Path "$ENV:HOME" -Name "$DirPath" -ItemType "directory" -Force 2>&1 | out-null
}

Get-ChildItem -Force -File -Recurse | Foreach-Object {
    $Fullpath = $_.FullName
    $FilenamePath = $_.FullName | Resolve-Path -Relative
    $FileName = $_.Name
    if ( $IsLinux ) { # used to block sertain configs in linux assuming .files allready exist.
        if ( $FileName -eq "starship.toml" )      { return } # continue used for Foreach-Object
        if ( $FileName -eq ".gitconfig" )         { return } # continue used for Foreach-Object
        if ( $FileNamePath.Contains('AppData') )  { return } # continue used for Foreach-Object
    }
    Write-Host " Creating softlink for $FileName" -ForegroundColor "DarkGray"
    New-Item -ItemType "SymbolicLink" -Path "$ENV:HOME/$FilenamePath" -Target $Fullpath -Force 2>&1 | out-null
}

Set-Location "$SCRIPT_DIR"

if ( $IsLinux ) {
    Write-Host "Nothing more to do on a linux system, we are done!" -ForegroundColor "DarkGreen"
    exit 0
}

Set-Location "$SCRIPT_DIR"
