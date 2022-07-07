Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Users\andre\.bin\check_dotfilestatus.cmd" & Chr(34), 0
Set WinScriptHost = Nothing