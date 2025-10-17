. "$PSScriptRoot\gather_classes.ps1"
. "$PSScriptRoot\daysTranslator.ps1"

$classes = gatherClasses

$classes = daysTranslator $classes

#$classes

#Deliverable 1:
function deli1(){
    $classes | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | `
    Where-Object { $_."Instructor" -eq "Furkan Paligu"}
}

#deli1

#Deliverable 2:

function deli2(){

    $classes | Where-Object{ ($_.Location -eq "JOYC 310") -and ($_.Days -eq "Monday") } | `
    Sort-Object "Time Start" | `
    Select-Object "Time Start", "Time End", "Class Code" 

}
#deli2

#Deliverable 3:
function deli3(){
    $ITSInstructors = $classes |
        Where-Object {
            ($_."Class Code" -like "SYS*") -or
            ($_."Class Code" -like "NET*") -or
            ($_."Class Code" -like "SEC*") -or
            ($_."Class Code" -like "FOR*") -or
            ($_."Class Code" -like "CSI*") -or
            ($_."Class Code" -like "DAT*")
        } |
        Select-Object "Instructor" -Unique |
        Sort-Object "Instructor"

    $ITSInstructors
}
#deli3

#Deliverable 4:

function deli4(){
    $classes |
        Where-Object { $_.Instructor -in $ITSInstructors.Instructor } |`
        Group-Object "Instructor" |`
        Select-Object Count, Name |`
        Sort-Object Count -Descending
}
#deli4