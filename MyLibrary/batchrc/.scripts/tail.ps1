if ( -not $args[0] ) {
    Write-Host "usage: tail [file] [filter]"
} elseif ( $args[0] -and -not $args[1] ) {
    Get-Content $args[0] -wait -tail $($Host.UI.RawUI.WindowSize.Height-2)
} else {
    Get-Content $args[0] -wait -tail $($Host.UI.RawUI.WindowSize.Height-2) | Select-String -NoEmphasis -Patter $args[1]
}