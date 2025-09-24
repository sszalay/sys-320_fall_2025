# Dot-source the functions from the first script
. .\function_event_logs_3.ps1

# calling
Write-Output "=== Logon / Logoff Events (last 7 days) ==="
Get-LogonLogoffEvents -DaysBack 7 | Format-Table -AutoSize

Write-Output "`n=== Startup / Shutdown Events (last 7 days) ==="
Get-StartupShutdownEvents -DaysBack 7 | Format-Table -AutoSize
