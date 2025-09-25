$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '

$regex = [regex] "(\d{1,3}\.){3}\d{1,3}"

$ips_unorganized = $regex.Matches($notfounds)

$ips = @()
for($i=0; $i  -lt $ips_unorganized.Count; $i++){
 $ips += [PSCustomObject]@{ "IP" = $ips_unorganized[$i].Value}
}

$ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*"}
$counts = $ipsoftens | Group-Object -Property IP
$counts | Select-Object Count, Name