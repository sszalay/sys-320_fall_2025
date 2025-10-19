
# Challenge 2

$logFile = "C:\xampp/htdocs\access.log"

$logs = @()

Get-Content $logFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq "") { return }   # skip blanks

    # Split by space once for the IP
    $ip = $line.Split(" ")[0]

    # extract the time inside of brackets
    $timeStart = $line.IndexOf("[") + 1
    $timeEnd = $line.IndexOf("]")
    $time = $line.Substring($timeStart, $timeEnd - $timeStart)

    # extract the request inside of the first quotes
    $firstQuote = $line.IndexOf('"')
    $secondQuote = $line.IndexOf('"', $firstQuote + 1)
    $request = $line.Substring($firstQuote + 1, $secondQuote - $firstQuote - 1)

    # split the request into method page and the protocol
    $reqParts = $request.Split(" ")
    $method = $reqParts[0]
    $page = if ($reqParts.Length -ge 2) { $reqParts[1] } else { "" }
    $protocol = if ($reqParts.Length -ge 3) { $reqParts[2] } else { "" }

    # get the response code 
    $afterRequest = $line.Substring($secondQuote + 1).Trim()
    $response = ($afterRequest -split "\s+")[0]

    # get the referrer next qoute
    $thirdQuote = $line.IndexOf('"', $secondQuote + 1)
    $fourthQuote = $line.IndexOf('"', $thirdQuote + 1)
    $referrer = ""
    if ($thirdQuote -ge 0 -and $fourthQuote -gt $thirdQuote) {
        $referrer = $line.Substring($thirdQuote + 1, $fourthQuote - $thirdQuote - 1)
    }

    $logs += [PSCustomObject]@{
        IP        = $ip
        Time      = $time
        Method    = $method
        Page      = $page
        Protocol  = $protocol
        Response  = $response
        Referrer  = $referrer
    }
}
$logs | Format-Table -AutoSize
