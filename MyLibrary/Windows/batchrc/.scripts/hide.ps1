foreach ($string in Get-ChildItem -Name) {
    if ($string -match 'scoop') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }
    if ($string -match 'MicrosoftEdgeBackups') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }
    if ($string -match 'PowerShell') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }
    if ($string -match 'WindowsPowerShell') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }

    if ($string -match 'ansel') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }

    # Any object containing a . infornt of its name
    if ($string -match '^\.') {
        (get-item $string).Attributes += 'Hidden'
        continue
    }
}