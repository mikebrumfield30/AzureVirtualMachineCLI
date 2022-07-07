#! /bin/bash

# Example CLI command for creating a VM with a managed identity

RESOURCE_GROUP_NAME='rg-exampleGroupWithIdentity'
VM_NAME='myVM-with-identity'
REGION='centralus'
SUBSCRIPTION_ID=""
SUBSCRIPTION_NAME="/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP_NAME"
ADMIN_USERNAME='azureuser'
ADMIN_PASSWORD='MySecur3P@ssw0rd'
IMAGE_NAME='CentOS'


echo "Creating Resource Group"
az group create --name $RESOURCE_GROUP_NAME --location $REGION

echo "Creating VM...."
az vm create --resource-group $RESOURCE_GROUP_NAME \
	--name $VM_NAME \
    --image $IMAGE_NAME \
	--generate-ssh-keys \
	--assign-identity \
	--role contributor \
	--scope $SUBSCRIPTION_NAME \
	--admin-username $ADMIN_USERNAME \
	--admin-password $ADMIN_PASSWORD

# stop a VM
# az vm stop --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME
# start a VM
# az vm start --resource-group $RESOURCE_GROUP_NAME --name $VM_NAME

# curl command to get access token from VM
# curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' -H Metadata:true