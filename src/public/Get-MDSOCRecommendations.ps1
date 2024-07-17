<#
.SYNOPSIS
    Get-MDSOCRecommendations retrieves the Microsoft SOC recommendations.

.DESCRIPTION
    Get-MDSOCRecommendations retrieves the Microsoft SOC recommendations from the specified Microsoft Sentinel workspace.

.PARAMETER AppId
    The Entra application ID.

.PARAMETER AppSecret
    The Entra application secret.

.PARAMETER TenantName
    The tenant name.

.PARAMETER WorkspaceName
    The name of the workspace.

.PARAMETER ResourceGroupName
    The name of the resource group.

.PARAMETER SubscriptionId
    The Azure subscription ID.

.EXAMPLE
    .\Get-MDSOCRecommendations.ps1 -AppId "your-app-id" -AppSecret "your-app-secret" -TenantName "your-tenant-name" -workspaceId "your-workspace-id" -WorkspaceName "your-workspace-name" -ResourceGroupName "your-resource-group-name" -SubscriptionId "your-subscription-id"
#>
function Get-MDSOCRecommendations {
[cmdletbinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "The Entra application ID.")]
    [string]$AppId,

    [Parameter(Mandatory = $true, HelpMessage = "The Entra application secret.")]
    [string]$AppSecret,

    [Parameter(Mandatory = $true, HelpMessage = "The tenant name.")]
    [string]$TenantName,

    [Parameter(Mandatory = $true, HelpMessage = "The name of the workspace.")]
    [string]$WorkspaceName,

    [Parameter(Mandatory = $true, HelpMessage = "The name of the resource group.")]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "The Azure subscription ID.")]
    [string]$SubscriptionId
)

try {
    #The scope of the authentication request. Typically, this is "https://management.azure.com/.default" for Azure resources.
    $Scope = "https://management.azure.com/.default"
    # Construct token endpoint URL
    $Url = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

    # Create body for authentication request
    $Body = @{
        client_id     = $AppId
        client_secret = $AppSecret
        scope         = $Scope
        grant_type    = 'client_credentials'
    }

    $PostSplat = @{
        ContentType = 'application/x-www-form-urlencoded'
        Method      = 'POST'
        Body        = $Body
        Uri         = $Url
    }

    try {
        # Request the access token
        $TokenRequest = Invoke-RestMethod @PostSplat -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to obtain access token: $_"
        return
    }

    # Create headers for API request
    $Header = @{
        Authorization = "$($TokenRequest.token_type) $($TokenRequest.access_token)"
    }

    $Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$WorkspaceName/providers/Microsoft.SecurityInsights/recommendations?api-version=2024-01-01-preview"

    try {
        $Results = Invoke-RestMethod -Uri $Uri -Headers $Header -Method GET -ContentType "application/json" -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to retrieve recommendations: $_"
        return
    }

    $Objects = @()
    ForEach ($recommendation in $Results.value) {
        $Object = [PSCustomObject]@{
            Id                      = $recommendation.id
            name                    = $recommendation.name
            type                    = $recommendation.type
            properites              = $recommendation.properties
            state                   = $recommendation.properties.state
            title                   = $recommendation.properties.title
            description             = $recommendation.properties.description
            creationTimeUtc         = $recommendation.properties.creationTimeUtc
            lastEvaluatedTimeUtc    = $recommendation.properties.lastEvaluatedTimeUtc
            lastModifiedTimeUtc     = $recommendation.properties.lastModifiedTimeUtc
            suggestions             = $recommendation.properties.suggestions
            additionalProperties    = $recommendation.properties.additionalProperties
        }
        # Add the IP object to the array
        $Objects += $Object
    }

    $Objects
}
catch {
    Write-Error "An unexpected error occurred: $_"
}
}