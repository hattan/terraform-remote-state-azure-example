#!/bin/bash
#set -euo pipefail
#IFS=$'\n\t'
 
# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

me=$0

postfix=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
storage_account_name="tfdemo$postfix"
storage_account_rg="tf_demo_store"
storage_account_rg_location="westus2"
network_resource_group="tf_demo_network"
network_container_name="network"
network_key="network.tfstate"
app_container_name="app"
vm_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)
vm_username="randomuser$postfix"

echo "Creating State Storage Resource Group: $storage_account_rg in $storage_account_rg_location"
az group create -n $storage_account_rg -l $storage_account_rg_location

echo "Creating State Storage Account: storage_account_name:"
az storage account create -n $storage_account_name -g $storage_account_rg -l $storage_account_rg_location --sku Standard_LRS

echo "Creating Network Container: $network_container_name"
az storage container create --name $network_container_name --account-name $storage_account_name

echo "Creating App Container: $network_container_name"
az storage container create --name $app_container_name --account-name $storage_account_name

echo "Fetching State Storage Account Key:"
storage_key=$(az storage account keys list --account-name $storage_account_name --query [0].value -o tsv)

echo "Writing Network Configuration File:"
mkdir -p network/config
echo "storage_account_name  = \"$storage_account_name\"" > network/config/state_storage.config
echo "container_name  = \"$network_container_name\"" >> network/config/state_storage.config
echo "key  = \"$network_key\"" >> network/config/state_storage.config
echo "encrypt  = \"true\"" >> network/config/state_storage.config
echo "region  = \"$storage_account_rg_location\"" >> network/config/state_storage.config
echo "access_key  = \"$storage_key\"" >> network/config/state_storage.config

echo "Writing App Tfvars File:"
echo "network_storage_account_name  = \"$storage_account_name\"" > app/network.auto.tfvars
echo "network_container_name  = \"$network_container_name\"" >> app/network.auto.tfvars
echo "network_storage_key  = \"$network_key\"" >> app/network.auto.tfvars
echo "network_access_key  = \"$storage_key\"" >> app/network.auto.tfvars
echo "vm_username=\"$vm_username\"" >> app/app.auto.tfvars
echo "vm_password=\"$vm_password\"" >> app/app.auto.tfvars

echo "Writing App Configuration File:"
mkdir -p app/config
echo "storage_account_name  = \"$storage_account_name\"" > app/config/state_storage.config
echo "container_name  = \"app\"" >> app/config/state_storage.config
echo "key  = \"app.tfstate\"" >> app/config/state_storage.config
echo "encrypt  = \"true\"" >> app/config/state_storage.config
echo "region  = \"$storage_account_rg_location\"" >> app/config/state_storage.config
echo "access_key  = \"$storage_key\"" >> app/config/state_storage.config



