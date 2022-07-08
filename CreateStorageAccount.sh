#! /bin/bash

# This script shows an example of using a managed identity to create a storage account within a resource group.
# It shows REST calls that are used to 1) Get an access token for the managed identity and 2) Using that access token to create a 
# storage account with the Azure REST API
# I am using jq to format the JSON response. It is not installed by default on CentOS by can be installed via yum
# jq can be installed using -> yum install -y epel-release; yum install -y jq

# The REST response includes an access_token that can be used against the REST API for Azure
# The URL is specific to azure and will route your request to the nearest available endpoint for the Azure resource API
SUBSCRIPTION_ID=$1
STORAGE_ACCOUNT_NAME=$2
RESOURCE_GROUP_NAME='rg-exampleGroupWithIdentity'
access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' -H Metadata:true | jq -r '.access_token')

# Create storage account
curl -X PUT "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT_NAME?api-version=2018-02-01" \
    -d '{"sku": {"name": "Standard_GRS"},"kind": "StorageV2","location": "centralus"}' \
    --header "Authorization: Bearer $access_token" \
    --header "Content-Type: application/json"

# List storage accounts (Only shows one's in the current resource group)
curl "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/providers/Microsoft.Storage/storageAccounts?api-version=2021-09-01" \
    --header "Authorization: Bearer $access_token" \
    --header "Content-Type: application/json" | jq "."