#use an account that can make role assignments
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

#Gets the RDS-tenant. USe the corresponding name in the next command
Get-RdsTenant

#assigns the RDS Owner role to the principal for the tenant we created
$myTenantName = "<Windows Virtual Desktop Tenant Name>"
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $myTenantName

#Signs in with the service principals as a test
$creds = New-Object System.Management.Automation.PSCredential($svcPrincipal.AppId, (ConvertTo-SecureString $svcPrincipalCreds.Value -AsPlainText -Force))
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $creds -ServicePrincipal -AadTenantId $aadContext.TenantId.Guid