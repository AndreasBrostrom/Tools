if ( -not $args[0] ) {
    Write-Host "usage: tail [file] [filter]"
} elseif ( $args[0] -and -not $args[1] ) {
    Get-Content $args[0] -wait
} else {
    Get-Content $args[0] -wait | Select-String -Patter $args[1]
}