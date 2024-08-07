

$operator  = $args[0]
$target    = $args[1]
$name      = $args[2]
$option    = ""
$force     = $false


if ( $operator -eq "-s" )  { $option = "SymbolicLink" }
if ( $operator -eq "-sf" ) { $option = "SymbolicLink"; $force= $true }
if ( $operator -eq "-j" )  { $option = "Junction" }
if ( $operator -eq "-jf" ) { $option = "Junction"; $force= $true }
if ( $operator -eq "-h" )  { $option = "HardLink" }
if ( $operator -eq "-hf" ) { $option = "HardLink"; $force= $true }

if ( !$args ) { Write-Host "ln: missing file operand`nTry 'ln --help' for more information."; exit 1 }

if ($operator -eq "--help" ) {
    Write-Host "Usage: ln [OPTION] TARGET NAME"
    Write-Host ""
    Write-Host "Mandatory arguments:"
    Write-Host "  -s        create a symbolic link"
    Write-Host "  -j        create a junction"
    Write-Host "  -h        create a hard link"
    Write-Host "  -f        force"
    exit 0
}

if ( $option -notin "SymbolicLink", "Junction", "HardLink" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }
if ( !$args[1] ) { Write-Host "Missing argument: target" -ForegroundColor Red; exit 1 }
if ( !$args[2] ) { Write-Host "Missing argument: link" -ForegroundColor Red; exit 1 }
if ( !$args[0] ) { Write-Host "Missing options" -ForegroundColor Red; exit 1 }


$targetFullPath = Get-Item -LiteralPath $target | % { $_.FullName }

if ( $targetFullPath -ne $null ) { $targetFullPath = (Get-Item $target).fullname } else {
    Write-Host "Target '$target' does not exist..." -ForegroundColor Red; exit 1
}

if (!$force -and ( ( [System.IO.File]::Exists($name) ) -or ( [System.IO.Directory]::Exists($name) ) ) ) {
    Write-Host "Name '$name' already exist." -ForegroundColor Red; exit 1
} else {
    Remove-Item -Path $name -Force -ErrorAction SilentlyContinue
}

if ( $operator -eq "-j" -and  !( (Get-Item $targetFullPath) -is [System.IO.DirectoryInfo]) ) { 
    Write-Host "Target '$target' is not a directory." -ForegroundColor Red; exit 1
}

if ( ( [System.IO.File]::Exists($targetFullPath) ) -or ( [System.IO.Directory]::Exists($targetFullPath) ) ) { 
    New-Item -ItemType $option -Value $targetFullPath -Path $name >$null 2>&1
    Write-Host "$targetFullPath -> $name"
} else {
    Write-Host "Target '$target' does not exist..." -ForegroundColor Red; exit 1
}
