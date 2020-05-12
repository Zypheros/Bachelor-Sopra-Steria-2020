<#

    .SYNOPSIS
        Script som oppretter en VM som skal brukes av Azure Migrate.

    .DESCRIPTION
        * Sjekker først om Hyper-V modulen er installert, hvis ikke blir den installert.
        * Kobler opp MigrateAppliance.vdh til MigrateApplianceVM
        * Setter antall prosessorer på MigrateApplianceVm til å være lik 8, og spesifiserer vektbalanse på 
          fysisk server i forhold til resurssbruk
        * Kobler til nettverksadaptere, både intern og ekstern   

    .NOTES
        AUTHOR: Endre Aalrust
        LASTEDIT: Feb 20, 2020    
#>



if(!(Get-Module -ListAvailable -Name *hyper-v*)){
    Write-Verbose "Installing Hyper-V module"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
    }
        
    New-VM `
    -Name MigrateApplianceVm `
    -Path "D:\Hyper-V\VMs" `
    -MemoryStartupBytes 8GB
    Write-Verbose "New VM MigrateApplianceVm created."
    
    
    Set-VMProcessor MigrateApplianceVm -Count 8 -Reserve 20 -Maximum 80 -RelativeWeight 5000
    Add-VMNetworkAdapter -VMName MigrateApplianceVm -SwitchName "Realtek PCIe GBE Family Controller - Virtual Switch" -Name External -DeviceNaming On
    Add-VMNetworkAdapter -VMName MigrateApplianceVm -SwitchName "Internal Only switch" -Name Internal -DeviceNaming On
    Add-VMHardDiskDrive -VMName MigrateApplianceVm -Path "C:\migrateApp\AzureMigrateAppliance_v2.19.11.12\Virtual Hard Disks\14393.0.amd64fre.rs1_release.160715-1616_server_serverdatacentereval_en-us.vhd"
    Start-VM -Name MigrateApplianceVm
    
    
    
    
    
    
    
    