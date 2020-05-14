
# SCript for making an VM-image
# Requires the AZ-module-

$vmName = "VMNAME"
$rgName = "Resource Group"
$location = "location"
$imageName = "name of resulting image"

Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force
Set-AzVM -ResourceGroupName $rgName -Name $vmName -Generalized

$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName
$image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.Id

New-AzImage -Image $image -ImageName $imageName -ResourceGroupName $rgName
