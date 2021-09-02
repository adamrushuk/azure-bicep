# Azure Blueprints

## Blueprint Assignment

Assign an existing blueprint using the examples below:

### Az CLI Example

```bash
# !  The management group scope for blueprint assignment is not supported yet. Please use --subscription for subscription scope
# https://docs.microsoft.com/en-us/cli/azure/blueprint/assignment?view=azure-cli-latest#az_blueprint_assignment_create
az blueprint assignment create --name "function-app-powershell-ghAssignment" --location "uksouth" --identity-type "SystemAssigned" \
  --description "Enforce pre-defined function-app-powershell-gh to this subscription." \
  --blueprint-version "/providers/Microsoft.Management/managementGroups/parent-mg/providers/Microsoft.Blueprint/blueprints/function-app-powershell-gh/versions/1.0.0" \
  --management-group "parent-mg" --debug
```

### Az CLI REST Example

**Not sure if Management Group scope assignment is possible for subscription-scoped blueprints?!**

The example below shows a Blueprint Assignment with system-assigned managed identity at management group scope:

```bash
# https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest#az_rest
# https://docs.microsoft.com/en-us/rest/api/blueprints/assignments/create-or-update

# var
# Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}').
MANAGEMENT_GROUP="parent-mg"
RESOURCE_SCOPE="/providers/Microsoft.Management/managementGroups/${MANAGEMENT_GROUP}"
ASSIGNMENT_NAME="MgBpAssignment"
API_VERSION="2018-11-01-preview"
REST_URI="https://management.azure.com/${RESOURCE_SCOPE}/providers/Microsoft.Blueprint/blueprintAssignments/${ASSIGNMENT_NAME}?api-version=${API_VERSION}"

# create
# https://docs.microsoft.com/en-us/rest/api/blueprints/assignments/create-or-update#assignment-with-system-assigned-managed-identity-at-management-group-scope
az rest --method put --url $REST_URI --body @blueprints/rest_blueprint_assignment.json
```

### PowerShell Example

```powershell
# vars
$ManagementGroupId = "parent-mg"
$BlueprintName = "function-app-powershell-gh"
$BlueprintAssignmentName = "myAssignment"
# $BlueprintAssignmentParams = @{P1="v1"; P2="v2"}
$BlueprintAssignmentParams = @{}

# login
Connect-AzAccount -UseDeviceAuthentication
Get-AzContext

# [OPTIONAL] install blueprint module
Install-Module Az.Blueprint -Verbose

# get
# https://docs.microsoft.com/en-us/powershell/module/az.blueprint/get-azblueprint?view=azps-6.3.0
$blueprintObject =  Get-AzBlueprint -ManagementGroupId $ManagementGroupId -Name $BlueprintName -Verbose
$blueprintObject

# assign
# https://docs.microsoft.com/en-us/powershell/module/az.blueprint/new-azblueprintassignment?view=azps-6.3.0
$azBlueprintAssignmentParams = @{
    Name              = $BlueprintAssignmentName
    Blueprint         = $blueprintObject
    ManagementGroupId = $ManagementGroupId
    Location          = "uksouth"
    # Parameter         = $BlueprintAssignmentParams
    Lock              = "AllResourcesDoNotDelete"
    Verbose           = $true
}
New-AzBlueprintAssignment @azBlueprintAssignmentParams

# update
Set-AzBlueprintAssignment @azBlueprintAssignmentParams

# remove
Remove-AzBlueprintAssignment -Name $BlueprintAssignmentName -ManagementGroupId $ManagementGroupId -Verbose
```
