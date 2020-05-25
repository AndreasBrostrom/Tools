if ( -not $args[0] ) {
    Write-Host "usage: which [program]"
} else {
    # if error
    Get-Command $args[0] >$null 2>&1
    if (-not $?) {
        Write-Host "Program does not exist"
        return
    }

    # check program
    if ((Get-Command $args[0]).CommandType -eq "ExternalScript") {
        (Get-Command $args[0] -ShowCommandInfo).Definition
    } elseif ((Get-Command $args[0]).CommandType -eq "Application") {
        (Get-Command $args[0] -ShowCommandInfo).Definition
    } elseif ((Get-Command $args[0]).CommandType -eq "Alias") {
        Write-Host "$((Get-Command $args[0]).CommandType) $((Get-Command $args[0]).Name) -> $((Get-Command $args[0]).Definition) ($((Get-Command $((Get-Command $args[0]).Definition)).CommandType))"
    } elseif ((Get-Command $args[0]).CommandType -eq "Function") {
        Write-Host "$((Get-Command $args[0]).CommandType) $((Get-Command $args[0]).Name)"
    } else {
        Get-Command $args[0] -ShowCommandInfo
    }
}