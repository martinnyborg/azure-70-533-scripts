# Login to azure (Comment out when already logged in)
# Login-AzAccount

# Resource Group
$resorceGroupName = "contoso"
Remove-AzureRmResourceGroup -Name $resorceGroupName

$location = "West Europe"
New-AzureRmResourceGroup -Name $resorceGroupName -Location $location

# App Service Plan
$appServicePlanName = "contoso"
$tier = "Premium"
$workerSize = "Small"
New-AzureRmAppServicePlan -Name $appServicePlanName -Location $location -ResourceGroupName $resorceGroupName -Tier $tier -WorkerSize $workerSize

# Web app
$webAppName = "mnt-contoso-hr-app"
New-AzureRmWebApp -ResourceGroupName $resorceGroupName -Name $webAppName -Location $location -AppServicePlan $appServicePlanName

# New 'Dev' deployment slot ( atleast Standard is required to create additional deployment slots)
$devSlotName = "Dev"
New-AzureRmWebAppSlot -ResourceGroupName $resorceGroupName -Name $webAppName -Slot $devSlotName

# Clone 'Dev' deployment slot ( atleast Premium is required to clone)
$stagingSlotName ="Staging"
$devSite = Get-AzureRmWebAppSlot -ResourceGroupName $resorceGroupName -Name $webAppName -Slot $devSlotName
New-AzureRmWebAppSlot -ResourceGroupName $resorceGroupName -Name $webAppName -Slot $stagingSlotName -AppServicePlan $appServicePlanName -SourceWebApp $devSite

# Swap deployment slots/webapps ('Dev' -> 'Staging'). Single phase swap
Swap-AzureRmWebAppSlot -SourceSlotName $devSlotName -DestinationSlotName $stagingSlotName -ResourceGroupName $resorceGroupName -Name $webAppName 

# Swap deployment slots/webapps ('Dev' -> 'Staging'). Multi phase swap (DestinationSlot config is copied to Source Slot)
#Swap-AzureRmWebAppSlot -SourceSlotName $devSlotName -DestinationSlotName $stagingSlotName -ResourceGroupName $resorceGroupName -Name $webAppName -SwapWithPreviewAction ApplySlotConfig
#Swap-AzureRmWebAppSlot -SourceSlotName $devSlotName -DestinationSlotName $stagingSlotName -ResourceGroupName $resorceGroupName -Name $webAppName -SwapWithPreviewAction CompleteSlotSwap
