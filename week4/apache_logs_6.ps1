$A = Get-Content -Path C:\xampp\apache\logs\*.log | Select-String -Pattern "error"

$A[-5..-1]