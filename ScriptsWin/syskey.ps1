param (
    [Parameter(Mandatory=$false)][Switch]$help,
    [Parameter(Mandatory=$false)][Switch]$list
)

if ( $help ) {
    Write-Host  "Usage: syskey"
    Write-Host  ""
    Write-Host  "    -h, -help          show this help"
    Write-Host  "    -l, -list          show current keybinding rule"
    exit 0
}

# Get Key Hex
$currentKey = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout\' |
  Select-Object -ExpandProperty 'Scancode Map' | Join-String $currentKey

"Current Hex: " + $currentKey
if ( $list ) {
    if ( -not $currentKey -or @("00000000300058058010100000", "000000003000580580580100000", "0000000020005805800000", "00000000200010100000", "000000002000105800000").Contains($currentKey) ) { $keybindingTable += @(
      @{Key="CAPSLOCK";Rebinding="CAPSLOCK"}
    )}
    if ( -not $currentKey -or @("00000000300058058010100000", "0000000030001058010100000", "0000000030001010105800000", "00000000200010100000", "0000000020005805800000", "000000002000580100000").Contains($currentKey) ) { $keybindingTable += @(
      @{Key="ESC";Rebinding="ESC"}
    )}
    if ( @("000000003000580580580100000", "000000002000580100000").Contains($currentKey) ) { $keybindingTable += @(
      @{Key="ESC";Rebinding="CAPSLOCK"}
    )}
    if ( @("0000000030001058010100000", "0000000030001010105800000", "000000002000105800000").Contains($currentKey) ) { $keybindingTable += @(
      @{Key="CAPSLOCK";Rebinding="ESC"}
    )}
    if ( $currentKey -eq "00000000300010580580100000" ) { $keybindingTable += @(
      @{Key="CAPSLOCK";Rebinding="ESC"}
      @{Key="ESC";Rebinding="CAPSLOCK"}
    )}
    
    $keybindingTable | % { New-Object object | Add-Member -NotePropertyMembers $_ -PassThru }
     | Sort-Object -Property Key | Format-Table -Property Key, Rebinding

    exit 0
}
