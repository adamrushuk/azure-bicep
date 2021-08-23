# Deploy a subscription-scoped resource

Deployment code for [Exercise - Deploy a subscription-scoped resource](https://docs.microsoft.com/en-gb/learn/modules/deploy-resources-scopes-bicep/4-exercise-deploy-subscription-scoped-resource?pivots=cli)

```bash
# naviagate into example folder
cd deploy-resources-scopes-bicep

# upgrade the azure cli
az upgrade

# upgrade or install the Bicep tooling
az bicep upgrade

# sign in to azure by using azure cli
az login

# deploy the template to Azure
templateFile="main.bicep"
today=$(date +"%d-%b-%Y")
deploymentName="sub-scope-"$today

az deployment sub create \
    --name $deploymentName \
    --location westus \
    --template-file $templateFile


# CLEANUP
subscriptionId=$(az account show --query 'id' --output tsv)
az policy assignment delete --name 'DenyFandGSeriesVMs' --scope "/subscriptions/$subscriptionId"
az policy definition delete --name 'DenyFandGSeriesVMs' --subscription $subscriptionId
```
