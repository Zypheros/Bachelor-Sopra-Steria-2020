<#
    
    .DESCRIPTION
    Skriptet installerer chocolatey som er et pakkeverktøy.
    Deretter benyttes chocolatey til å installere mysql

    .NOTES
    Author: Emil Brasø

#>

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y mysql