#! /bin/bash

# This script shows a sample rest call that can be used to get an access token on a VM that has a managed identity. 

# The REST response includes an access_token that can be used against the REST API for Azure
# The URL is specific to azure and will route your request to the nearest available endpoint for the Azure resource API
# I am using jq to format the JSON response
curl \
    'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' \
    -H Metadata:true | jq '.'
