

$operator  = $args[0]
$option    = ""



if ( $operator -eq "a" ) { $option = "address" }
if ( $operator -eq "ad" ) { $option = "address" }
if ( $operator -eq "add" ) { $option = "address" }
if ( $operator -eq "addr" ) { $option = "address" }
if ( $operator -eq "addr" ) { $option = "address" }
if ( $operator -eq "addre" ) { $option = "address" }
if ( $operator -eq "addres" ) { $option = "address" }
if ( $operator -eq "address" ) { $option = "address" }
if ( $operator -eq "help" ) { $option = "help" }

if ( !$args ) { "ln: missing file operand`nTry 'ln --help' for more information."; exit }

if ( ($operator -eq "help") -or !($args) -or !($args[0]) ) {
    "Usage: ip OBJECT { COMMAND | help }"
    "where  OBJECT := { address }"
    ""
    exit 1
}

if ( $option -notin "address" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }

if ( $option -eq "address" ) { 
    Get-NetIPConfiguration -All; exit 0
}