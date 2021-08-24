# Azure Bicep Examples

## Deploy a subscription-scoped resource

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
    --template-file $templateFile \
    --confirm-with-what-if


# CLEANUP
subscriptionId=$(az account show --query 'id' --output tsv)
az policy assignment delete --name 'DenyFandGSeriesVMs' --scope "/subscriptions/$subscriptionId"
az policy definition delete --name 'DenyFandGSeriesVMs' --subscription $subscriptionId
```

## Deploy resources to multiple scopes by using modules

Deployment code for [Exercise - Deploy resources to multiple scopes by using modules](https://docs.microsoft.com/en-gb/learn/modules/deploy-resources-scopes-bicep/6-exercise-deploy-multiple-scopes-modules?pivots=cli)

```bash
# deploy the template to Azure
templateFile="deploy-resources-scopes-bicep/main.bicep"
today=$(date +"%d-%b-%Y")
deploymentName="sub-scope-"$today
virtualNetworkName="rnd-vnet-001"
virtualNetworkAddressPrefix="10.0.0.0/24"

az deployment sub create \
    --name $deploymentName \
    --location westus \
    --template-file $templateFile \
    --parameters virtualNetworkName=$virtualNetworkName \
                    virtualNetworkAddressPrefix=$virtualNetworkAddressPrefix \
    --confirm-with-what-if


# CLEANUP
subscriptionId=$(az account show --query 'id' --output tsv)
az policy assignment delete --name 'DenyFandGSeriesVMs' --scope "/subscriptions/$subscriptionId"
az policy definition delete --name 'DenyFandGSeriesVMs' --subscription $subscriptionId
az group delete --name ToyNetworking
```

## Deploy resources to a management group

Deployment code for [Exercise - Deploy resources to a management group](https://docs.microsoft.com/en-gb/learn/modules/deploy-resources-scopes-bicep/7-exercise-deploy-management-group?pivots=cli)

```bash
# create a management group
az account management-group create \
  --name SecretRND \
  --display-name "Secret R&D Projects"

# deploy the template to Azure
managementGroupId="SecretRND"
templateFile="management-group-policy/main.bicep"
today=$(date +"%d-%b-%Y")
deploymentName="mg-scope-"$today

az deployment mg create \
    --management-group-id $managementGroupId \
    --name $deploymentName \
    --location westus \
    --template-file $templateFile \
    --parameters managementGroupName=$managementGroupId \
    --confirm-with-what-if


# CLEANUP
az account management-group delete --name SecretRND
```
