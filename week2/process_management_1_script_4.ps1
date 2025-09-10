
# checks if Chrome is running
$chrome = Get-Process -Name "chrome" -ErrorAction SilentlyContinue

if ($chrome) {
    # if running stop all instances
    Stop-Process -Name "chrome" -Force
    Write-Output "Chrome was running and has been stopped."
} else {
    # if not running start Chrome and open champlain.edu
    Start-Process "chrome.exe" "https://www.champlain.edu"
    Write-Output "Chrome was not running and has been started."
}
