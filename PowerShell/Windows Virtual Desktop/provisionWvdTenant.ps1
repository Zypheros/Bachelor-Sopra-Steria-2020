Install-Module -Name Microsoft.RDInfra.RDPowerShell
Import-Module -Name Microsoft.RDInfra.RDPowerShell
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
New-RdsTenant -Name azureMigrateTestOrg -AadTenantId "tenant-id-goes-here" -AzureSubscriptionId "subscription-id-goes-here"