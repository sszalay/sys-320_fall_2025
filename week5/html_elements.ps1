$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.26/ToBeScraped.html

$scraped_page.Links | Select-Object outerText, href, innerText

$h2s=$scraped_page.ParsedHtml.body.getElementsByTagName("h2")
$h2s

$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | where {
    $_.getAttributeNode("class").Value -ilike "*div-1*"
} | select innerText

$divs1
