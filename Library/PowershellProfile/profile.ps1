
function prompt { (Write-Host ($env:UserName + '@' + $env:ComputerName) -ForegroundColor Green -NoNewline) + (Write-Host ': PS ' -NoNewline) + (Write-Host (get-location)  -ForegroundColor Blue -NoNewline ) + '> '}

$curren_path = ($pwd).path
if (!(Compare-Object "$curren_path" "C:\Windows\system32")) { set-location "$env:userprofile" }

# Aliases
Set-Alias -Name py -Value python

# Windows dir macro extentions
if ($PSVersionTable.PSVersion.major -eq 6) {
    function alias_ls { Get-ChildItem -Name }
    Set-Alias -Name ls -Value alias_ls
}

function alias_ll { Get-ChildItem -Hidden }
Set-Alias -Name ll -Value alias_ll

function alias_la { Get-ChildItem -Name -Hidden }
Set-Alias -Name la -Value alias_la

function alias_l  { Get-ChildItem -Name }
Set-Alias -Name l  -Value alias_l
