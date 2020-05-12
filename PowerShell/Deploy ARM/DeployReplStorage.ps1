$templateFile = "C:\Users\Emil.EMIL-HP\Documents\GitHub\Bachelor2020\ARM\ReplicationApplication.json"
New-AzResourceGroupDeployment `
  -Name addnameparameter `
  -ResourceGroupName myResourceGroupTest `
  -TemplateFile $templateFile `
  -storageName "repl1eab220120" `
  -storageSKU Standard_GRS