if ( $args[0] -eq "now" ) {
    Start-Process -FilePath "C:\Windows\system32\shutdown.exe" -ArgumentList "/s /t 0"
    exit 0
}

Start-Process -FilePath "C:\Windows\system32\shutdown.exe" -ArgumentList "$args"