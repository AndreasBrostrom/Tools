

$operator  = $args[0]
$target    = $args[1]
$name      = $args[2]
$option    = ""
$force     = $false


if ( $operator -eq "-s" ) { $option = "SymbolicLink" }
if ( $operator -eq "-sf" ) { $option = "SymbolicLink"; $force= $true }
if ( $operator -eq "-j" ) { $option = "Junction" }
if ( $operator -eq "-jf" ) { $option = "Junction"; $force= $true }
if ( $operator -eq "-h" ) { $option = "HardLink" }
if ( $operator -eq "-hf" ) { $option = "HardLink"; $force= $true }

if ( !$args ) { "ln: missing file operand`nTry 'ln --help' for more information."; exit }

if ($operator -eq "--help" ) {
    "Usage: ln [OPTION] TARGET NAME`nMandatory arguments:"
    "  -s            create a symbolic link"
    "  -j            create a junction"
    "  -h            create a hard link"
    exit
}

if ( $option -notin "SymbolicLink", "Junction", "HardLink" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }
if ( !$args[1] ) { Write-Host "Missing argument: target" -ForegroundColor Red; exit }
if ( !$args[2] ) { Write-Host "Missing argument: link" -ForegroundColor Red; exit }
if ( !$args[0] ) { Write-Host "Missing options" -ForegroundColor Red; exit }

$targetFullPath = Get-Item $target -ErrorAction SilentlyContinue 
if ( $targetFullPath -ne $null ) { $targetFullPath = (Get-Item $target).fullname } else {
    Write-Host "Target '$target' does not exist..." -ForegroundColor Red; exit
}

if (!$force -and ( ( [System.IO.File]::Exists($targetFullPath) ) -or ( [System.IO.Directory]::Exists($targetFullPath) ) ) ) {
    Write-Host "Name '$name' already exist." -ForegroundColor Red; exit
} else {
    Remove-Item -Path $name -Force -ErrorAction SilentlyContinue 
}

if ( $operator -eq "-j" -and  !( (Get-Item $targetFullPath) -is [System.IO.DirectoryInfo]) ) { 
    Write-Host "Target '$target' is not a directory." -ForegroundColor Red; exit 
}

if ( ( [System.IO.File]::Exists($targetFullPath) ) -or ( [System.IO.Directory]::Exists($targetFullPath) ) ) { 
    New-Item -ItemType $option -Value $targetFullPath -Path $name >$null 2>&1
} else {
    Write-Host "Target '$target' does not exist..." -ForegroundColor Red
}
