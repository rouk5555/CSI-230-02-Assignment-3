. (Join-Path $PSScriptRoot functions.ps1)

clear

$loginOutsTable = GetLoginOffEvents(14)
$loginOutsTable

$shutdownsTable = GetShutdownEvents(14)
$shutdownsTable

$startupsTable = GetStartupEvents(14)
$startupsTable