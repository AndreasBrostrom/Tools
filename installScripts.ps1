#Copy-Item -Path "ScriptsWin" -Destination C:\Programs\Bin
#
#New-Item -ItemType SymbolicLink -Path "Link" -Target "Target"
#
#Get-ChildItem
#
Write-host "Copying scripts to C:/bin/."
ForEach ($filePath in Get-ChildItem "ScriptsWin") {
    #Write-host "$($filePath.name) -> C:/bin/$($filePath.name)" 
    New-Item -ItemType SymbolicLink -Target "$filePath" -Path "C:/bin/$($filePath.name)" -Force
}
