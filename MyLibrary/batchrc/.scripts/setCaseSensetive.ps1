
if ( "$args" -eq "" ) { $path="." } else { $path=$args }
fsutil.exe file SetCaseSensitiveInfo $path enable