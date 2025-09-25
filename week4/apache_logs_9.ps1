function Get-ApacheIPs {
    param(
        [string]$Page,
        [string]$HttpCode,
        [string]$Browser
    )
    # this reads the log file
    $logPath = "C:\xampp\apache\logs\access.log"
    $logs = Get-Content $logPath

    # regex for IP addresses
    $ipRegex = [regex]"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

    # this filters the logs by the given page, HTTP code,and browser
    $filteredLogs = $logs | Where-Object {
        $_ -match $Page -and $_ -match $HttpCode -and $_ -match $Browser
    }

    # extract IP addresses
    $ips = foreach ($line in $filteredLogs) {
        $match = $ipRegex.Match($line)
        if ($match.Success) {
            [PSCustomObject]@{ IP = $match.Value }
        }
    }

    # count occurrences of each IP like in the last script
    $counts = $ips | Group-Object -Property IP
    return $counts | Select-Object Count, Name
}
