// Bicep example for a PowerShell Function App

// Params
@description('The name of the function app that you wish to create.')
param appName string = 'funtionapp-${uniqueString(resourceGroup().id)}'

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageAccountType string = 'Standard_LRS'

@description('The URL for the GitHub repository that contains the project to deploy.')
param repoURL string = 'https://github.com/adamrushuk/azure-function-app'

@description('The branch of the GitHub repository to use.')
param branch string = 'main'

@description('Location for all resources.')
param location string = resourceGroup().location


// Variables
var functionAppName_var = appName
var hostingPlanName_var = '${appName}-plan'
var storageAccountName_var = '${uniqueString(resourceGroup().id)}functions'


// Resources
// https://docs.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?tabs=bicep
resource storageAccountName 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName_var
  location: location
  kind: 'Storage'
  sku: {
    name: storageAccountType
  }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms?tabs=bicep
resource hostingPlanName 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName_var
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  // properties: {
  //   name: hostingPlanName_var
  //   computeMode: 'Dynamic'
  // }
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites?tabs=bicep
resource functionAppName 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName_var
  location: location
  kind: 'functionapp'
  properties: {
    // name: functionAppName_var
    serverFarmId: hostingPlanName.id
    clientAffinityEnabled: false
    siteConfig: {
      // cors: {
      //   allowedOrigins: [
      //     '*'
      //   ]
      // }
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listkeys(storageAccountName.id, '2021-04-01').keys[0].value};'
        }
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listkeys(storageAccountName.id, '2021-04-01').keys[0].value};'
        }
      ]
      powerShellVersion: '~7'
    }
  }
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/sourcecontrols?tabs=bicep
resource functionAppName_web 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
  parent: functionAppName
  name: 'web'
  properties: {
    repoUrl: repoURL
    branch: branch
    isManualIntegration: true
  }
}


// Outputs
output functionAppUrl string = functionAppName.properties.defaultHostName
