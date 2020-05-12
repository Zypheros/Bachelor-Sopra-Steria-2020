#koble til Azure
Connect-AzAccount

#deklarer filstier
$templatefile = "testDepl"
$templateParameterFile = "sti"

#deklarer ressursgruppen
$resourceGroup = "Test1604"

#rull ut på ressursgruppen
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile $templatefile -TemplateParameterFile $templateParameterFile