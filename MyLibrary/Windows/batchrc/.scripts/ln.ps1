

$operator  = $args[0]
$target    = $args[1]
$name      = $args[2]
$option    = ""

if ( $operator -eq "-s" ) { $option = "SymbolicLink" }
if ( $operator -eq "-j" ) { $option = "Junction" }
if ( $operator -eq "-h" ) { $option = "HardLink" }
if ( $operator -eq "--shim") { $option = "shim" }
if ( $operator -eq "-m" ) { $option = "shim" }

if ( !$args ) { "ln: missing file operand`nTry 'ln --help' for more information."; exit }

if ($operator -eq "--help" ) {
    "Usage: ln [OPTION] TARGET NAME`nMandatory arguments:"
    "  -s            create a symbolic link"
    "  -j            create a junction"
    "  -h            create a hard link"
    "  -m  --shim    create a shim if non exist else it gets copied"
    exit
}

if ( $option -notin "SymbolicLink", "Junction", "HardLink", "shim" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }
if ( !$args[1] ) { Write-Host "Missing argument: target" -ForegroundColor Red; exit }
if ( !$args[2] ) { Write-Host "Missing argument: link" -ForegroundColor Red; exit }
if ( !$args[0] ) { Write-Host "Missing options" -ForegroundColor Red; exit }


if ( $option -ne "shim" ) {
    if ( [System.IO.File]::Exists($target) -or [System.IO.Directory]::Exists($target) ) { 
        New-Item -ItemType $option -Value $target -Path $name >$null 2>&1
    } else {
        Write-Host "Target '$target' does not exist..." -ForegroundColor Red
    }
} else {
    if ( "$target" -like "*shim*" ) {
        Write-Host "'$target' is already a shim copying instead..." -ForegroundColor Yellow
        Copy-Item "$target" -Destination "$PWD" >$null 2>&1
    } else {
        Write-Host "Creating shim" -ForegroundColor White
        shimgen -p "$target" -o "$PWD\$name" >$null 2>&1
    }
}
