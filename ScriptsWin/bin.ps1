$target    = $args[0]
$name      = $args[1]

shimgen -p "$target" -o "C:\bin\$name" >$null 2>&1
shimgen -p "$target" -o "C:\bin\$name.exe" >$null 2>&1