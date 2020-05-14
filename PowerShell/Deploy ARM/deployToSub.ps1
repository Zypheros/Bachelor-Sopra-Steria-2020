$templateFile = "Path"
$name = "name of deployment"
$location = "target location"

New-AzDeployment -Name $name -Location $location -TemplateFile $templateFile