Login-AzureRmAccount

# Create a Resource Group
$rgName   = "linux-templ-rg"
$location = "WestEurope"
New-AzureRmResourceGroup -Name $rgName -Location $location

# Deploy a Template from GitHub
#$deploymentName = "simpleVMDeployment"
#$templateUri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/
#master/101-vm-simple-windows/azuredeploy.json"
#New-AzureRmResourceGroupDeployment -Name $deploymentName `
#                                   -ResourceGroupName $rgName `
#                                   -TemplateUri $templateUri

# Deploy a Template from a file
$deploymentName = "\\Mac\iCloud\Azure\chapter2simpleVMDeployment"
$templateFile = "\\Mac\iCloud\Azure\chapter2\template.json"
$parametersFile = "parametersFile.json"
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templateFile -TemplateParameterFile $parametersFile