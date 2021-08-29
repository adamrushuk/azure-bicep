#!/usr/bin/env bash

# function app (powershell)

# vars
REGION="uksouth"
RESOURCE_GROUP_NAME="AzureFunctionsQuickstart-rg"
STORAGE_ACCOUNT_NAME="adamrushukstacc"
FUNCTION_APP_NAME="adamrushukfuncapp"

az login

az group create --name "$RESOURCE_GROUP_NAME" --location "$REGION"

az storage account create --name "$STORAGE_ACCOUNT_NAME" --location "$REGION" --resource-group "$RESOURCE_GROUP_NAME" --sku Standard_LRS

az functionapp create --resource-group "$RESOURCE_GROUP_NAME" --consumption-plan-location "$REGION" --runtime powershell --functions-version 3 --name "$FUNCTION_APP_NAME" --storage-account "$STORAGE_ACCOUNT_NAME" --os-type Linux --runtime-version 7.0


# CLEANUP
az group delete --name "$RESOURCE_GROUP_NAME"



