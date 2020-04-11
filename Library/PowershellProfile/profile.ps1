#function prompt { (Write-Host ($env:UserName + '@' + $env:ComputerName) -ForegroundColor Green -NoNewline) + (Write-Host ': PS ' -NoNewline) + (Write-Host (get-location)  -ForegroundColor Blue -NoNewline ) + '> '}
#function prompt { (Write-Host 'PS ' -NoNewline) + (Write-Host (get-location)  -ForegroundColor Blue -NoNewline ) + ' > '}
function prompt { (Write-Host (get-location)  -ForegroundColor Blue -NoNewline ) + (Write-Host ' PS>' -ForegroundColor DarkGray -NoNewline) + ' '}

# Windows linux conversions
$curren_path = ($pwd).path
if (!(Compare-Object "$curren_path" "C:\Windows\system32")) { set-location "$env:userprofile" }

# tail program
function tail {
    if ( -not $args[0] ) {
        Write-Host "usage: tail [file] [filter]"
    } elseif ( $args[0] -and -not $args[1] ) {
        Get-Content $args[0] -wait
    } else {
        Get-Content $args[0] -wait | Select-String -Patter $args[1]
    }
}

# which program
function which {
    if     ((Get-Command $args).CommandType -eq "ExternalScript") { (Get-Command $args -ShowCommandInfo).Definition }
    elseif ((Get-Command $args).CommandType -eq "Application") { (Get-Command $args -ShowCommandInfo).Definition }
    elseif ((Get-Command $args).CommandType -eq "Alias") {
        Write-Host "$((Get-Command $args).CommandType) $((Get-Command $args).Name) -> $((Get-Command $args).Definition) ($((Get-Command $((Get-Command $args).Definition)).CommandType))"
    }
    elseif ((Get-Command $args).CommandType -eq "Function") {
        Write-Host "$((Get-Command $args).CommandType) $((Get-Command $args).Name)"
    }
    else {
        Get-Command $args -ShowCommandInfo
    }
}

# Windows dir macro extentions
$FileHiddenPrefix = ".*"
if ($PSVersionTable.PSVersion.major -eq 6) {
    function lssys { Get-ChildItemColorFormatWide $args -Exclude $FileHiddenPrefix }
    Set-Alias -Name ls -Value lssys
}
function ll { Get-ChildItem $args -Force -Exclude NTUSER* }
function la { Get-ChildItemColorFormatWide $args -Force -Exclude NTUSER*}
function l  { Get-ChildItemColorFormatWide $args -Exclude $FileHiddenPrefix }

# Programs
Set-Alias -Name py -Value python
Set-Alias -Name vim -Value nvim