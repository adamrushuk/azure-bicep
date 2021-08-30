# Function App Deployment

## Resource Group Scope Deployment

```bash
# navigate to example
cd blueprints/function-app-dedicated-github-deploy

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="funcapp-dedicate-github-rg"
DEPLOYMENT_NAME="funcapp-dedicated"

# login
az login

# create a new resource group for your deployment
az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

# deploy function app into resource group
az deployment group create --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME" --template-file azuredeploy.json


# CLEANUP
# this does NOT remove resources; just the deployment history
az deployment group delete --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME"

# remove resources
az group delete --name "$RESOURCE_GROUP_NAME"
```

## WIP - Management Group Scope Deployment

<!-- TODO

```bash
# navigate to example
cd blueprints/function-app-dedicated-github-deploy

# vars
REGION="uksouth"
MANAGEMENT_GROUP_NAME="parent-mg"
# RESOURCE_GROUP_NAME="funcapp-dedicate-github-rg"
DEPLOYMENT_NAME="mg-funcapp-dedicated"

# login
az login

# deploy function app into resource group
az deployment mg create --management-group-id "$MANAGEMENT_GROUP_NAME" --name "$DEPLOYMENT_NAME" --location "$REGION" --template-file azuredeploy.json


# CLEANUP
# this does NOT remove resources; just the deployment history
az deployment group delete --resource-group "$RESOURCE_GROUP_NAME" --name "$DEPLOYMENT_NAME"

# remove resources
az group delete --name "$RESOURCE_GROUP_NAME"
```
-->
