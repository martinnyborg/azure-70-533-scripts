Login-AzAccount

$resorceGroupName = "contoso"
$location = "West Europe"
$tier = "Basic"
$workerSize = "Small"
$appServicePlanName = "contoso"

New-AzureRmResourceGroup -Name $resorceGroupName -Location $location
New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -ResourceGroupName $resorceGroupName -Tier $tier -WorkerSize $workerSize

$webAppName = "mnt-contoso-hr-app"
New-AzureRmWebApp -ResourceGroupName $resorceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName