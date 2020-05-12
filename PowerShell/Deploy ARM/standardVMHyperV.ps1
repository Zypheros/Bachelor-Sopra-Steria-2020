<#

    .SYNOPSIS
        Script som oppretter en standard VM for bruk som arbeidsstasjon

    .DESCRIPTION
        * Sjekker først om Hyper-V modulen er installert, hvis ikke blir den installert.
        * Oppretter Workstation.vdhx med 85GB lagringsplass.
        * Oppretter WorkstationVm med 4GB ram
        * Kobler opp Workstation.vdhx til WorkstationVM
        * Kobler opp en windows-iso fil til WorkstationVM
        * Setter antall prosessorer på WorkstationVM til å være lik 8, og spesifiserer vektbalanse på 
          fysisk server i forhold til resurssbruk   

    .NOTES
        AUTHOR: Emil Brasø
        LASTEDIT: Feb 26, 2020    
#>


if(!(Get-Module -ListAvailable -Name *hyper-v*)){
    Write-Verbose "Installing Hyper-V module"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
}

if(!)
$workStationNr
$vhdPath = "D:\Hyper-V\VHDS\Workstation.vhdx"
$vhdSize = 85GB
New-VHD -Path $vhdPath -Dynamic -SizeBytes $vhdSize `
Write-Verbose "New disk MigrateAppliance.vdhx created."

New-VM `
-Path "D:\Hyper-V\VMs" `
-MemoryStartupBytes 16GB
Write-Verbose "New VM MigrateApplianceVm created."


Add-VMHardDiskDrive -VMName MigrateApplianceVm -Path "D:\Hyper-V\VHDS\MigrateAppliance.vhdx"
Set-VMDvdDrive -VMName MigrateApplianceVm -ControllerNumber 1 -Path "D:\ISO\win10.iso"
Set-VMProcessor MigrateApplianceVm -Count 8 -Reserve 20 -Maximum 80 -RelativeWeight 5000


