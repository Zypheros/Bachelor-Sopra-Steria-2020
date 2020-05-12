$templateFile = "C:\Users\Emil.EMIL-HP\Documents\GitHub\Bachelor2020\ARM\azureMigrate\migrateProject.json"
$timestamp = get-date -Format "yyyy-MM-dd"
New-AzResourceGroupDeployment -Name migrateTest -ResourceGroupName testMiljø -TemplateFile $templateFile -todayDate $timestamp