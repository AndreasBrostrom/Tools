
$operator  = $args[0]
$targets   = ($args[1])

$name      = "chmod"
$option    = ""

if ( $operator -eq "+x" )        { $option = "Unblock-File" }
if ( $operator -eq "-x" )        { $option = "Block-File" }
if ( $operator -eq "--help" )    { $option = "Help" }

if ( !$args ) { "${name}: missing file operand`nTry '$name --help' for more information."; exit }

if ($option -eq "Help" ) {
    "Usage: $name [OPTION] TARGET NAME`nMandatory arguments:"
    "  +x            unblock file"
    "  -x            block file"
    exit
}

if ( $option -notin "Unblock-File", "Block-File", "Help" ) { Write-Host "'$operator' invalid option" -ForegroundColor Red; exit }
if ( !$args[1] ) { Write-Host "Missing argument: target" -ForegroundColor Red; exit }
if ( !$args[0] ) { Write-Host "Missing options" -ForegroundColor Red; exit }


if ( $option -eq "Unblock-File" ) {
    $targets = Get-ChildItem $targets -ErrorAction 'SilentlyContinue'
    
    foreach ($obj in $targets ) {
        Unblock-File -Path $obj
    }
}
