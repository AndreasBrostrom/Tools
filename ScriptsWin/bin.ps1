$name       = $args[0]
$altName    = $args[1]

$target = which $name

if (!$altName) {
    $name = $altName
}

shimgen -p "$target" -o "C:\bin\$name" >$null 2>&1
shimgen -p "$target" -o "C:\bin\$name.exe" >$null 2>&1

write-host "'$target' have been added to windows bin."