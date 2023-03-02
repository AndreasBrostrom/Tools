# Powershell Windows Administration
Require password on windows admin commands.

``` pwsh
sudo Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1
```

