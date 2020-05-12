<#

    .SYNOPSIS
        Script som laster net Migrate Appliance .VHD for Hyper-V

    .DESCRIPTION
        * Setter sikekrhetsinstillinger for å sikre at nedlastning er mulig
        * Laster ned .VHD-en
        * sjekker sikkerheten på .zip mappen

    .NOTES
        AUTHOR: Emil Brasø
        LASTEDIT: Feb 26, 2020

#>



[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
$url = "https://aka.ms/migrate/appliance/hyperv"
$output = "$PSScriptRoot\migrateAppliance"
$start_time = Get-Date

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
Get-FileHash -Path ./migrateAppliance.zip -Algorithm SHA256
