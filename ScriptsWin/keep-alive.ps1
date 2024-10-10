$WShell = New-Object -com "Wscript.Shell"

while ($true) {
  if ($args[0] -eq "--verbose" -or $args[0] -eq "-v") {
    write-host "Keep alive triggered..."
  }
  $WShell.sendkeys("{SCROLLLOCK}")
  Start-Sleep -Milliseconds 100  
  $WShell.sendkeys("{SCROLLLOCK}")
  Start-Sleep -Seconds 180
}
