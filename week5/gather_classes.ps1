#function 1
function gatherClasses(){

$page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.26/Courses2025FA.html

$trs = $page.ParsedHtml.getElementsByTagName("tr")

$FullTable = @()
for($i=1; $i -lt $trs.length; $i++){

    $tds = $trs[$i].getElementsByTagName("td")

    $Times = $tds[5].innerText.Split("-")

    $FullTable += [PSCustomObject]@{
        "Class Code" = $tds[0].innerText
        "Title" = $tds[1].innerText
        "Days" = $tds[4].innerText
        "Time Start" = $Times[0].Trim()
        "Time End" = $Times[1].Trim()
        "Instructor" = $tds[6].innerText
        "Location" = $tds[9].innerText
    
    }
}
return $FullTable
}
#function 1 end

#function 2
function daysTranslator($FullTable){

    for($i=0; $i -lt $FullTable.length; $i++){
    
        $Days = @()

        if($FullTable[$i].Days -ilike "*M*") { $Days += "Monday" }

        if($FullTable[$i].Days -ilike "*T[^H]*") { $Days += "Tuesday" }

        elseif ($FullTable[$i].Days -ilike "T") { $Days += "Tuesday" }

        if ($FullTable[$i].Days -ilike "*W*") { $Days += "Wednesday" }

        if ($FullTable[$i].Days -ilike "*TH*") { $Days += "Thursday" }

        if ($FullTable[$i].Days -ilike "*F*") { $Days += "Friday" }

        $FullTable[$i].Days = $Days

    }
return $FullTable
}
#function 2 end
               