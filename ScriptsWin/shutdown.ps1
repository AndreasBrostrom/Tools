if ( $args[0] -eq "now" ) {
    Start-Process -FilePath "C:\Windows\system32\shutdown.exe" -ArgumentList "/s /t 0"
    exit 0
}

$cmdOutput = (C:\Windows\system32\shutdown.exe $args)
$cmdOutput