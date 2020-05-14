$templateFile = "Path"
$name = "name of deployment"
$resourceGroup = "target resource group"

New-AzResourceGroupDeployment -Name $name -ResourceGroupName $resourceGroup -TemplateFile $templateFile