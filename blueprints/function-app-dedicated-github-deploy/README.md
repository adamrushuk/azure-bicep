# Function App Deployment

## Resource Group Scope Deployment

```bash
# navigate to example
cd blueprints/function-app-dedicated-github-deploy

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="funcapp-dedicate-github-rg"
DEPLOYMENT_NAME="funcapp-dedicated"
TEMPLATE_FILENAME="azuredeploy.json"

# login
az login

# create a new resource group for your deployment
az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

# deploy function app into resource group
az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME" --template-file $TEMPLATE_FILENAME --confirm-with-what-if


# CLEANUP
# this does NOT remove resources; just the deployment history
az deployment group delete --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME"

# remove resources
az group delete --name "$RESOURCE_GROUP_NAME"
```
