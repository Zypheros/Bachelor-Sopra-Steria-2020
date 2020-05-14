Connect-AzureAD

#install modul AzureAd om ikke ekisterende
Install-Module AzureAD
Import-Module AzureAD

#oppretter Service principalen på nytt
New-AzureAdServicePrincipal -AppId "2565bd9d-da50-47d4-8b85-4c97f669dc36"