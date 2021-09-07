# Event Grid Function App Deployment

## Bicep - Subscription Scope Deployment

```bash
# navigate to example
cd event-grid-function-app

# vars
LOCATION="uksouth"
DEPLOYMENT_NAME="sub-event-grid-funcapp"
BICEP_TEMPLATE_FILENAME="subscriptionScope.bicep"

# login
az login
az account show

# deploy function app into subscription
az deployment sub create --location "$LOCATION" --name "$DEPLOYMENT_NAME" --template-file $BICEP_TEMPLATE_FILENAME --confirm-with-what-if

# show outputs
# TODO

# CLEANUP
# TODO

# [OPTIONAL] convert Bicep to ARM config
az bicep build --file $BICEP_TEMPLATE_FILENAME

# [OPTIONAL] decompile from ARM JSON to Bicep
az bicep decompile --file arm.json
```

## Bicep - Resource Group Scope Deployment

```bash
# navigate to example
cd event-grid-function-app

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="rg-event-grid-funcapp"
DEPLOYMENT_NAME="event-grid-funcapp"
BICEP_TEMPLATE_FILENAME="resourceGroupScope.bicep"

# login
az login
az account show

# create a new resource group for your deployment
az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

# deploy function app into resource group
az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME" --template-file $BICEP_TEMPLATE_FILENAME --confirm-with-what-if

# show outputs
az deployment group show -g "$RESOURCE_GROUP_NAME" -n "$DEPLOYMENT_NAME" -o tsv --query properties.outputs.functionAppUrl.value

# CLEANUP
az group delete --name "$RESOURCE_GROUP_NAME"

# [OPTIONAL] convert Bicep to ARM config
az bicep build --file $BICEP_TEMPLATE_FILENAME

# [OPTIONAL] decompile from ARM JSON to Bicep
az bicep decompile --file arm.json
```
