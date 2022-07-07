# add check_dotfilestatus.vbs in to regular intervalls

Start-Sleep 10

if ( -Not (git -C "$HOME/Repositories/wdotfiles" status | Select-String "nothin" -quiet) ) {
    Write-Host "Changes detected (dotfiles)"

    Add-Type -AssemblyName System.Windows.Forms
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    #$path = (Get-Process -id $pid).Path
    $path = "C:\Programs\.icon\dotfile.ico"
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
    $balloon.BalloonTipText = 'You have dirty and uncommited dotfiles'
    $balloon.BalloonTipTitle = "Uncommited dotfiles" 
    $balloon.Visible = $true 
    $balloon.ShowBalloonTip(50000)
}

Start-Sleep 60