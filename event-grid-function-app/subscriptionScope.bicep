// Subscription scope required for RoleAssignment

// Scope
targetScope = 'subscription'

// Params
@description('The name of the Resource Group that you wish to create.')
param rgName string = 'rg-event-grid-funcapp'

@description('Location for all resources.')
param location string = 'uksouth'

// Resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module functionApp './resourceGroupScope.bicep' = {
  scope: resourceGroup
  name: 'funcApp'
}

resource subContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: guid(functionApp.name, subscription().subscriptionId)
  properties: {
    principalId: functionApp.outputs.functionAppPrincipalId
    // contributor RBAC role
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
}
