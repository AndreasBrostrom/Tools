

$operator  = $args[0]
$target    = $args[1]
$name      = $args[2]
$option    = ""



if ( $operator -eq "-s" ) { $option = "SymbolicLink" }
if ( $operator -eq "-j" ) { $option = "Junction" }
if ( $operator -eq "-h" ) { $option = "HardLink" }

if ( !$args ) { "ln: missing file operand`nTry 'ln --help' for more information."; exit }

if ($operator -eq "--help" ) {
    "Usage: ln [OPTION] TARGET NAME`nMandatory arguments:"
    "  -s            create a symbolic link"
    "  -j            create a junction"
    "  -h            create a hard link"
    exit
}

if ( $option -notin "SymbolicLink", "Junction", "HardLink", "shim" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }
if ( !$args[1] ) { Write-Host "Missing argument: target" -ForegroundColor Red; exit }
if ( !$args[2] ) { Write-Host "Missing argument: link" -ForegroundColor Red; exit }
if ( !$args[0] ) { Write-Host "Missing options" -ForegroundColor Red; exit }

$targetFullPath = (Get-ChildItem $target).fullname

if ( [System.IO.File]::Exists($targetFullPath) -or [System.IO.Directory]::Exists($targetFullPath) ) { 
    New-Item -ItemType $option -Value $targetFullPath -Path $name #>$null 2>&1
} else {
    Write-Host "Target '$target' does not exist..." -ForegroundColor Red
}
