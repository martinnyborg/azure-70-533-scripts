#/bin/bash
# az login

rgName="ubuntu-cli-rg"
location="WestEurope"
az group delete --name $rgName
az group create --name $rgName --location $location

# Creating a simple virtual machine (everything default configured)
#vmName="myUbuntuVM"
#imageName="UbuntuLTS"
#az vm create --resource-group $rgName --name $vmName --image $imageName --generate-ssh-keys

# Create a virtual network
vnetName="ubuntu-cli-vnet"
vnetAddressPrefix="10.0.0.0/16"
az network create --resource-group $rgName --name $vnetName --address-prefixes $vnetAddressPrefix --location $location

# Create subnets
subnet1Name="Subnet-1"
subnet2Name="Subnet-2"
subnet1AddressPrefix="10.0.1.0/24"
subnet2AddressPrefix="10.0.0.0/24"
az network vnet subnet create --resource-group $rgName --vnet-name $vnetName --name $subnet1Name --address-prefix $subnet1AddressPrefix
az network vnet subnet create --resource-group $rgName --vnet-name $vnetName --name $subnet2Name --address-prefix $subnet2AddressPrefix


