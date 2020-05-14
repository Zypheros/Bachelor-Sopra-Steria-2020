# Install-Module -Name Microsoft.RDInfra.RDPowerShell
# Import-Module -Name Microsoft.RDInfra.RDPowerShell
# Update-Module -Name Microsoft.RDInfra.RDPowerShellK9

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

#name should be globally unique
New-RdsTenant -Name <TenantName> -AadTenantId <DirectoryID> -AzureSubscriptionId <SubscriptionID>

#give another user access, just in case
New-RdsRoleAssignment -TenantName <TenantName> -SignInName <Upn> -RoleDefinitionName "RDS Owner"
