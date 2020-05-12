<#

    .SYNOPSIS
        Scriptet kjører en cleanup i et azure miljø.

    .DESCRIPTION
        Powershell script som benyttes til å kjøre en cleanup av azure miljøet. 
        Dette inebærer å slette alle ressurser som er utgått og ressursgrupper som ikke inneholder ressurser. 
        NB! For at dette skal fungere må alle ressurser ha en TAG <expireOn> som inneholder informasjon om når ressursen er utgått.

    .NOTES
        AUTHOR: Endre Aalrust, Emil Brasø
        LASTEDIT: Feb 12, 2020
        MODULES: Az.Accounts, Az.ResourceGraph, Az.Resources

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, 
        including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
        and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software

    .PARAMETER ResourceGroupWhitelistCSV
        En liste med resurssgrupper som ikke skal slettes.

    .PARAMETER deleteUnattachedDisks
        Sletter disker som ikke er tilknyttet en VM ved verdi 1. Hvis satt til 0 får bruker opp informasjon om alle disker som ikke er tilknyttet en VM.
#>

Param(
        [Parameter(Mandatory = $False)]  
        [string]$ResourceGroupWhitelistCSV ,
        [Parameter(Mandatory = $False)]
        [int]$deleteUnattachedDisks = 0
    )    

    $ResourceGroupWhitelist = $ResourceGroupWhitelistCSV.Split(',',[System.StringSplitOptions]::RemoveEmptyEntries)
    
    ############################################################################################
    #                                Oppkobling til azure konto                                #
    ############################################################################################


    $connectionName = "AzureRunAsConnection"
    try
    {
        # Get the connection "AzureRunAsConnection"
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

        Connect-AzAccount `
            -ServicePrincipal `
            -Tenant $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
    }
    catch {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } else{
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }


    ############################################################################################
    #                                Sletting av ressurser                                     #
    ############################################################################################
    $expResources = Search-AzGraph -Query 'where todatetime(tags.expireOn) < now() | project id'

    foreach ($r in $expResources) {
        Write-Output -Message "Deleting the Azure Resource $($r.id)"
        Remove-AzResource -ResourceId $r.id -Force
    }


    ################################################################################################
    #                               Sletting av ressursgrupper                                     #
    ################################################################################################

    $rgs = Get-AzResourceGroup;

    foreach($resourceGroup in $rgs){
        if($ResourceGroupWhitelist -notcontains $resourceGroup.Name){
            $name =  $resourceGroup.ResourceGroupName;
            $count = (Get-AzResource | Where-Object {$_.ResourceGroupName -match $name }).Count;
            if($count -eq 0){
                Write-Output -Message "Deleting the Azure Resourcegroup $Name"
                Remove-AzResourceGroup -Name $name -Force 
            }
        }   
    }

    ################################################################################################
    #                               Sletting av disker                                             #
    ################################################################################################

    # Set deleteUnattachedDisks = 1 if you want to delete unattached Managed Disks
    # Set deleteUnattachedDisks = 0 if you want to see the Id of the unattached Managed Disks
    $deleteUnattachedDisks
    $managedDisks = Get-AzDisk
    foreach ($md in $managedDisks) {
        # ManagedBy property stores the Id of the VM to which Managed Disk is attached to
        # If ManagedBy property is $null then it means that the Managed Disk is not attached to a VM
        if($md.ManagedBy -eq $null){
            if($deleteUnattachedDisks -eq 1){
                Write-Output "Deleting unattached Managed Disk with Id: $($md.Id)"
                $md | Remove-AzDisk -Force
                Write-Output "Deleted unattached Managed Disk with Id: $($md.Id) "
            }else{
                $md.Id
            }
        }
    }


