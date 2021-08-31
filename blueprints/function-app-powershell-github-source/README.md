# Function App (PowerShell) Deployment

## Resource Group Scope Deployment

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
```

## WIP - Management Group Scope Deployment

<!-- TODO -->
