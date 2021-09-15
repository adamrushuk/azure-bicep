// Event Grid Function App

// Scope
targetScope = 'resourceGroup'

// Params
@description('The name of the function app that you wish to create.')
param appName string = 'eg-funcapp-${uniqueString(resourceGroup().id)}'

@secure()
@description('The URL and SAS token of the function app package/zip file.')
param packageUrl string

@description('The name of the Event Grid System Topic that you wish to create.')
param systemTopicName string = 'mySystemTopic'

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageAccountType string = 'Standard_LRS'

// @description('The URL for the GitHub repository that contains the project to deploy.')
// param repoURL string = 'https://github.com/adamrushuk/azure-function-app'

// @description('The branch of the GitHub repository to use.')
// param branch string = 'main'

@description('Location for all resources.')
param location string = resourceGroup().location

// Variables (like locals{} in Terraform)
var functionAppName_var = appName
var applicationInsightsName_var = appName
var hostingPlanName_var = '${appName}-plan'
var storageAccountName_var = '${uniqueString(resourceGroup().id)}functions'

// Existing Resources (like Data Resources in Terraform)

// resource vnetResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
//   name: vnetResourceGroupName
//   scope: subscription().subscriptionId
// }

// Resources
// https://docs.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?tabs=bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
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
resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName_var
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
}

// https://docs.microsoft.com/en-gb/azure/templates/microsoft.insights/components?tabs=bicep
resource functionAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: applicationInsightsName_var
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: {
    // circular dependency means we can't reference functionApp directly "/subscriptions/<subscriptionId>/resourceGroups/<rg-name>/providers/Microsoft.Web/sites/<appName>"
    'hidden-link:/subscriptions/${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/sites/${functionAppName_var}': 'Resource'
  }
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites?tabs=bicep
resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName_var
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      powerShellVersion: '~7'
      appSettings: [
        // {
        //   'name': 'WEBSITE_RUN_FROM_PACKAGE'
        //   'value': packageUrl
        // }
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': functionAppInsights.properties.InstrumentationKey
        }
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
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listkeys(storageAccount.id, '2021-04-01').keys[0].value};'
        }
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listkeys(storageAccount.id, '2021-04-01').keys[0].value};'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listkeys(storageAccount.id, '2021-04-01').keys[0].value};'
        }
        // WEBSITE_CONTENTSHARE will be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        {
          name: 'INBOUND_NSG_RULE_NAME'
          value: 'inbound-test-rule'
        }
        {
          name: 'OUTBOUND_NSG_RULE_NAME'
          value: 'outbound-test-rule'
        }
      ]
    }
  }
}

resource msdeploy 'Microsoft.Web/sites/extensions@2021-01-15' = {
  parent: functionApp
  name: 'MSDeploy'
  properties: {
    packageUri: packageUrl
    // appOffline: true
  }
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/sourcecontrols?tabs=bicep
// resource functionAppSourcecontrol 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
//   parent: functionApp
//   name: 'web'
//   properties: {
//     repoUrl: repoURL
//     branch: branch
//     isManualIntegration: true
//   }
// }

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sourcecontrols?tabs=bicep#sourcecontrolproperties-object
// ! tenant-level scope so cant define here?
// resource functionAppSourcecontrolAuth 'Microsoft.Web/sourcecontrols@2020-12-01' = {
//   name: 'GitHub'
//   properties: {
//     token: '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'
//   }
// }

// https://docs.microsoft.com/en-gb/azure/templates/microsoft.eventgrid/systemtopics?tabs=bicep
resource systemTopic 'Microsoft.EventGrid/systemTopics@2020-04-01-preview' = {
  name: systemTopicName
  location: 'global'
  tags: {}
  properties: {
    source: subscription().id
    topicType: 'Microsoft.Resources.Subscriptions'
  }
}

// https://docs.microsoft.com/en-gb/azure/templates/microsoft.eventgrid/systemtopics/eventsubscriptions?tabs=bicep
resource systemTopicEventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-06-01-preview' = {
  parent: systemTopic
  name: 'my-event-subscription'
  properties: {
    destination: {
      properties: {
        resourceId: '${resourceId('Microsoft.Web/sites', appName)}/functions/EventGridTrigger1'
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
      }
      endpointType: 'AzureFunction'
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Resources.ResourceWriteSuccess'
        'Microsoft.Resources.ResourceDeleteSuccess'
      ]
      enableAdvancedFilteringOnArrays: true
      advancedFilters: [
        {
          values: [
            'Microsoft.Network/networkSecurityGroups/'
          ]
          operatorType: 'StringContains'
          key: 'data.operationName'
        }
      ]
    }
    labels: []
    eventDeliverySchema: 'EventGridSchema'
    retryPolicy: {
      maxDeliveryAttempts: 30
      eventTimeToLiveInMinutes: 1440
    }
  }
  dependsOn: [
    msdeploy
  ]
}

// Outputs
output functionAppUrl string = functionApp.properties.defaultHostName
output functionAppPrincipalId string = functionApp.identity.principalId
