
Get-Process | Where-Object { $_.Path -and $_.Path -notmatch "system32" }
