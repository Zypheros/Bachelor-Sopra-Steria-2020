
# Skript som benyttes til å lage et image av en VM
# Her benyttes AZ-modulen

$vmName = "MLTjener"
$rgName = "testmigration"
$location = "northeurope"
$imageName = "testImage"

Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force
Set-AzVM -ResourceGroupName $rgName -Name $vmName -Generalized

$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName
$image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.Id

New-AzImage -Image $image -ImageName $imageName -ResourceGroupName $rgName
