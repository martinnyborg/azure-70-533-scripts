﻿#Login-AzAccount

# Create a resource group for the VM
$resourceGroupName = "mnt-ps-ubuntu-serv-rg"
Remove-AzureRmResourceGroup -Name $resourceGroupName
$location = "West Europe"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network with two subnets
$subnets = @() #Empty array
$subnet1Name = "Subnet-1" 
$subnet2Name = "Subnet-2"
$subnet1AddressPrefix = "10.0.1.0/24" # 255.255.255.0 aka 10.0.1.*
$subnet2AddressPrefix = "10.0.0.0/24" # 255.255.255.0 aka 10.0.0.*
$subnets += New-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $subnet1AddressPrefix
$subnets += New-AzureRmVirtualNetworkSubnetConfig -Name $subnet2Name -AddressPrefix $subnet2AddressPrefix

$vnetAddressSpace = "10.0.0.0/16" # 255.255.0.0 aka 10.0.*.*
$vnetName = "mnt-ps-ubuntu-serv-vnet"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -AddressPrefix $vnetAddressSpace `
    -Subnet $subnets

# Create a storage account
$storageAccountName = "ubuntupsstorageacc"
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Location $location 

# Store blob endpoint for later use
$blobEndpoint = $storageAccount.PrimaryEndpoints.Blob.ToString()

# Create a new availability set
$availabilitySetName = "ubuntu-ps-availability-set"
$avSet = New-AzureRmAvailabilitySet -ResourceGroupName $resourceGroupName -Name $availabilitySetName -Location $location

# Setup public ip
$publicIpName = "ubuntu-serv-public-ip"
$domainNameLabel = "mnt-ubuntu-serv"
$publicip = New-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Location $location -Sku Basic -AllocationMethod Dynamic -DomainNameLabel $domainNameLabel

# Create network rules
$networkSecurityGroupRules = @()
$networkSecurityGroupRules += New-AzureRmNetworkSecurityRuleConfig -Name "SSH" `
    -Description "SSH Access" `
    -Protocol Tcp `
    -SourcePortRange "*" `
    -DestinationPortRange "22" `
    -SourceAddressPrefix "*" `
    -DestinationAddressPrefix "*" `
    -Access Allow `
    -Priority 100 `
    -Direction Inbound

# Create the network security group
$networkSecurityGroup = New-AzureRmNetworkSecurityGroup -Name "ubuntu-ps-nsg" `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -SecurityRules $networkSecurityGroupRules

# Create the network interface, binding the network setup together
$networkInterfaceName = "ubuntu-ps-nic"
$networkInterface = New-AzureRmNetworkInterface -Name $networkInterfaceName `
-ResourceGroupName $resourceGroupName `