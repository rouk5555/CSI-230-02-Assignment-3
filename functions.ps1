function GetLoginOffEvents {
    param (
        # Parameter for the num of days
        [int]$Days
    ) 

    # Get login/logoff records from the past "Days" days
    $loginouts = Get-EventLog system -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$Days)

    $loginoutsTable = @()  # Array to store results
    for($i=0; $i -lt $loginouts.Count; $i++){

        # Creating event
        $event = ""
        if($loginouts[$i].InstanceId -eq 7001) { $event="Logon" }
        if($loginouts[$i].InstanceId -eq 7002) { $event="Logoff" }

        # Creating user
        # Used ChatGPT to help with translation
        $idString = $loginouts[$i].ReplacementStrings[1]
        $id = New-Object System.Security.Principal.SecurityIdentifier($idString)
        $user = $id.Translate([System.Security.Principal.NTAccount])

        # Custom object
        $loginoutsTable += [pscustomobject]@{
            "Time"  = $loginouts[$i].TimeGenerated
            "Id"    = $loginouts[$i].InstanceId
            "Event" = $event
            "User"  = $user;
        }
    }

    # Return the table of results
    return $loginoutsTable
}

function GetStartupEvents {
    param (
        [int]$Days  # Parameter for num of days
    )

    # Get start-up records from the past days (Used ChatGPT to help)
    $startups = Get-EventLog -LogName System -After (Get-Date).AddDays(-$Days) |
                Where-Object { $_.EventID -eq 6005 }

    $startupTable = @()  # Array
    for($i=0; $i -lt $startups.Count; $i++){

        # Creating event
        $event = "Startup"

        # Creating user
        $user = "System"

        # Custom object
        $startupTable += [pscustomobject]@{
            "Time"  = $startups[$i].TimeGenerated
            "Id"    = $startups[$i].EventID
            "Event" = $event
            "User"  = $user;
        }
    }

    # Return the table of results
    return $startupTable
}

function GetShutdownEvents {
    param (
        [int]$Days  # Parameter for num days
    )

    # Get shut-down records from the past days (Used ChatGPT to help)
    $shutdowns = Get-EventLog -LogName System -After (Get-Date).AddDays(-$Days) |
                 Where-Object { $_.EventID -eq 6006 }

    $shutdownTable = @()  # Array
    for($i=0; $i -lt $shutdowns.Count; $i++){

        # Creating event
        $event = "Shutdown"

        # Creating user
        $user = "System"

        # Custom object
        $shutdownTable += [pscustomobject]@{
            "Time"  = $shutdowns[$i].TimeGenerated
            "Id"    = $shutdowns[$i].EventID
            "Event" = $event
            "User"  = $user;
        }
    }

    # Return the table of results
    return $shutdownTable
}
