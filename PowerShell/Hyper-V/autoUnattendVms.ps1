<#

    .SYNOPSIS
        Script som oppretter x antall vm'er spesifisert av brukeren.

    .DESCRIPTION
        * Sjekker fÃ¸rst om Hyper-V modulen er installert, hvis ikke blir den installert.
        * Oppretter autoUnattendedDisk.vdhx med 40GB lagringsplass.
        * Oppretter autoUnattendedVM med 8GB ram
        * Kobler opp autoUnattendedDisk.vdhx til autoUnattendedVM
        * Kobler opp en windows-iso fil til autoUnattendedVM
        * Setter antall prosessorer pÃ¥ autoUnattendedVM til Ã¥ vÃ¦re lik 8, og spesifiserer vektbalanse pÃ¥ 
          fysisk server i forhold til resurssbruk   

    .NOTES
        AUTHOR: Endre Aalrust, Emil Brasø
        LASTEDIT: Feb 20, 2020
        Code for building image: oscdimg.exe -m -o -u2 -udfver102 -bootdata:2#p0,e,bd:\iso_files\boot\etfsboot.com#pEF,e,bd:\iso_files\efi\microsoft\boot\efisys.bin d:\iso_files d:\14986PROx64.iso    
#>

$quantity = 'Skriv inn antall maskiner som skal opprettes: '
$counter = 0


if(!(Get-Module -ListAvailable -Name *hyper-v*)){
    Write-Verbose "Installing Hyper-V module"
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
}

while($counter -le $quantity){
    $vmName = Read-Host 'Skriv inn navn på maskinen: '
    $diskSize = Read-Host 'Skriv inn ønsket størrelse på disken: '
    $ram = Read-Host 'Skriv inn ønsket mengde RAM: ' 

    $vhdPath = "D:\Hyper-V\VHDS\$vmName.vhdx"
    New-VHD -Path $vhdPath -Dynamic -SizeBytes $diskSize `
    #Write-Verbose "New disk autoUnattendedVM.vdhx created."

    New-VM `
    -Name $vmName `
    -Path "D:\Hyper-V\VMs" `
    -MemoryStartupBytes $ram
    #Write-Verbose "New VM autoUnattendedVM created."


    Add-VMHardDiskDrive -VMName $vmName -Path "D:\Hyper-V\VHDS\$vmName.vhdx"
    Set-VMDvdDrive -VMName $vmName -ControllerNumber 1 -Path "D:\autoUnattend\ISO\14986PROx64.iso"
    #Set-VMProcessor autoUnattendedVM -Count 8 -Reserve 20 -Maximum 80 -RelativeWeight 5000 # Spesifiserer hvor mange kjerner vmen skal ha
    Start-VM -Name "$vmName"
    $counter++
}




