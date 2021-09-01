# Function App (PowerShell) Deployment

## ARM - Resource Group Scope Deployment

```bash
# navigate to example
cd blueprints/function-app-powershell-github-source

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="funcapp-powershell-github-rg"
DEPLOYMENT_NAME="funcapp-powershell"
TEMPLATE_FILENAME="powershell-windows-funcapp-azuredeploy.json"

# login
az login

# create a new resource group for your deployment
az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

# deploy function app into resource group
az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME" --template-file $TEMPLATE_FILENAME --confirm-with-what-if


# CLEANUP
az group delete --name "$RESOURCE_GROUP_NAME"

# [OPTIONAL] convert ARM to Bicep config
az bicep decompile --file $TEMPLATE_FILENAME
```

## Bicep - Resource Group Scope Deployment

```bash
# navigate to example
cd blueprints/function-app-powershell-github-source

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="funcapp-powershell-github-rg"
DEPLOYMENT_NAME="funcapp-powershell"
BICEP_TEMPLATE_FILENAME="powershell-windows-funcapp-azuredeploy.bicep"

# login
az login

# create a new resource group for your deployment
az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

# deploy function app into resource group
az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME" --template-file $BICEP_TEMPLATE_FILENAME --confirm-with-what-if

# show outputs
az deployment group show -g "$RESOURCE_GROUP_NAME" -n "$DEPLOYMENT_NAME" -o tsv --query properties.outputs.functionAppUrl.value

# CLEANUP
az group delete --name "$RESOURCE_GROUP_NAME"
```

## WIP - Management Group Scope Deployment

<!-- TODO -->
