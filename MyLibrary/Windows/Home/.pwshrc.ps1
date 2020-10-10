# Set prompt title
$host.ui.RawUI.WindowTitle = "Powershell Core"

# Set prompt to unix like
function prompt { (Write-Host ("$pwd".replace("$($home)", "~")) -ForegroundColor Blue -NoNewline) + (Write-Host ' PS>' -ForegroundColor DarkGray -NoNewline) + ' '}

# Windows linux conversions
$curren_path = ($pwd).path
if (!(Compare-Object "$curren_path" "C:\Windows\system32")) { set-location "$env:userprofile" }

# Windows dir macro extentions
$FileHiddenPrefix = ".*"

if ( Get-Module -ListAvailable -Name Get-ChildItemColor) {
    if ($PSVersionTable.PSVersion.major -gt 6) {
        function alias_fnc_ls { Get-ChildItemColorFormatWide $args -Exclude $FileHiddenPrefix }
        Set-Alias -Name ls -Value alias_fnc_ls
    }
    function ll { Get-ChildItem $args -Force -Exclude NTUSER* }
    function la { Get-ChildItemColorFormatWide $args -Force }
    function l  { Get-ChildItemColorFormatWide $args }
} else {
    if ($PSVersionTable.PSVersion.major -gt 6) {
        function alias_fnc_ls { Get-ChildItem $args -Exclude $FileHiddenPrefix | Format-Wide -AutoSize }
        Set-Alias -Name ls -Value alias_fnc_ls
    }
    function ll { Get-ChildItem $args -Force -Exclude NTUSER* }
    function la { Get-ChildItem $args -Force -Exclude NTUSER* | Format-Wide -AutoSize }
    function l  { Get-ChildItem $args | Format-Wide -AutoSize }
}

# Windows Unix extentions
function reboot { shutdown -r -t 0 $args }
function ifconfig { ipconfig /all $args }

# Aliases
if (Test-Path "$env:userprofile\.pwsh_aliases.ps1" -PathType leaf) {
    . "$env:userprofile\.pwsh_aliases.ps1"
}
if (Test-Path "$env:userprofile\.ps_aliases.ps1" -PathType leaf) {
    . "$env:userprofile\.ps_aliases.ps1"
}

# Path
if (Test-Path "$env:userprofile\.pwsh_path.ps1" -PathType leaf) {
    . "$env:userprofile\.pwsh_path.ps1"
}
if (Test-Path "$env:userprofile\.pwsh_path.ps1" -PathType leaf) {
    . "$env:userprofile\.pwsh_path.ps1"
}

