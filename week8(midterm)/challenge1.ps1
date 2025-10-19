
# Challenge 1

$page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.26/IOC-1.html
$trs  = $page.ParsedHtml.getElementsByTagName("tr")

$FullTable = @()
for ($i = 1; $i -lt $trs.length; $i++) {   # skip header row
    $tds = $trs[$i].getElementsByTagName("td")
    if ($tds.length -ge 2) {
        $FullTable += [PSCustomObject]@{
            Pattern     = ($tds[0].innerText).Trim()
            Explanation = ($tds[1].innerText).Trim()
        }
    }
}
$FullTable | Format-Table -AutoSize
