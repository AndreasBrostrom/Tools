
$target    = $args[0]
$operator  = $args[1]

$scriptName = "chown"
$option     = ""

if ( $operator -eq "--help" -or $target -eq "--help")    { $option = "Help" }

if ( !$args ) { "$($scriptName): missing file operand`nTry '$scriptName --help' for more information."; exit }

if ($option -eq "Help" ) {
    "Usage: $scriptName TARGET"
    exit 0
}

takeown /R /D Y /F $target