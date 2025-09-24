function Get-LogonLogoffEvents {
    param(
        [int]$DaysBack
    )

    $events = Get-EventLog -LogName System -InstanceId 7001,7002 -After (Get-Date).AddDays(-$DaysBack)

    $events | ForEach-Object {
        $username = $_.UserName
        if ($username -and $username -match '^S-1-') {
            try {
                $username = (New-Object System.Security.Principal.SecurityIdentifier($username)).
                            Translate([System.Security.Principal.NTAccount])
            } catch { }
        }

        $eventName = switch ($_.EventID) {
            7001 { "Logon" }
            7002 { "Logoff" }
            default { "Unknown" }
        }

        [PSCustomObject]@{
            Time  = $_.TimeGenerated
            Id    = $_.EventID
            Event = $eventName
            User  = $username
        }
    }
}

function Get-StartupShutdownEvents {
    param(
        [int]$DaysBack
    )

    $events = Get-EventLog -LogName System -InstanceId 6005,6006 -After (Get-Date).AddDays(-$DaysBack)

    $events | ForEach-Object {
        $eventName = switch ($_.EventID) {
            6005 { "Startup" }
            6006 { "Shutdown" }
            default { "Unknown" }
        }

        [PSCustomObject]@{
            Time  = $_.TimeGenerated
            Id    = $_.EventID
            Event = $eventName
            User  = "System"
        }
    }
}
