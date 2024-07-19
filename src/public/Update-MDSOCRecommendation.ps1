<#
.SYNOPSIS
    Update-MDSOCRecommendation updates the status of a Microsoft SOC recommendation.

.DESCRIPTION
    Update-MDSOCRecommendation updates the status of a  Microsoft SOC recommendation.

.PARAMETER State
    The state of the recommendation. This can be one of the following values: Active, InProgress, Dismissed, CompletedByUser, CompletedBySystem

.PARAMETER Reevaluation
    Triggers a reevaluation of the recommendation.

.PARAMETER Id
    The unique Id of the Recommendation. Use Get-MDSOCRecommendations to get the unique recommendation Id for a recommendatino.

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
    .\Set-MDSOCRecommendation -State "InProgress" -id "unique id"  -AppId "your-app-id" -AppSecret "your-app-secret" -TenantName "your-tenant-name" -WorkspaceName "your-workspace-name" -ResourceGroupName "your-resource-group-name" -SubscriptionId "your-subscription-id"

    .\Set-MDSOCRecommendation -Reevaluation -id "unique id"  -AppId "your-app-id" -AppSecret "your-app-secret" -TenantName "your-tenant-name" -WorkspaceName "your-workspace-name" -ResourceGroupName "your-resource-group-name" -SubscriptionId "your-subscription-id"
#>
function Update-MDSOCRecommendation {
    #[CmdletBinding()]
    [CmdletBinding(DefaultParameterSetName = 'StateSet')]
    param (
        [Parameter(ParameterSetName = 'StateSet', Mandatory = $true, HelpMessage = "Recommendation Status")]
        [ValidateSet('Active', 'InProgress', 'Dismissed', 'CompletedByUser', 'CompletedBySystem')]
        [string]$State,

        [Parameter(ParameterSetName = 'ReevaluationSet', Mandatory = $true, HelpMessage = "Indicates that the recommendation is being reevaluated.")]
        [switch]$Reevaluation,
        
        [Parameter(Mandatory = $true, HelpMessage = "Recommendation Id")]
        [string]$id,

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

    begin {
        if ($State -and $Reevaluation) {
            throw "You cannot specify both -State and -Reevaluation parameters."
        }
        if (-not $State -and -not $Reevaluation) {
            throw "You must specify either -State or -Reevaluation parameter."
        }
    }

    process {
        try {
            # The scope of the authentication request. Typically, this is "https://management.azure.com/.default" for Azure resources.
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

            if ($State) {
                $Body = @{
                    Properties = @{
                        State = $State
                    }
                } | ConvertTo-Json

                $Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$WorkspaceName/providers/Microsoft.SecurityInsights/recommendations/$id" + "?api-version=2024-01-01-preview"
                try {
                $Results = Invoke-RestMethod -Uri $Uri -Headers $Header -Body $Body -Method Patch -ContentType "application/json" -ErrorAction Stop
                }
                catch {
                    Write-Error "Failed to update recommendation: $_"
                    return
                }

            } elseif ($Reevaluation) {
                $Uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/$WorkspaceName/providers/Microsoft.SecurityInsights/recommendations/$id/triggerEvaluation" + "?api-version=2024-01-01-preview"
                Try{
                $Results = Invoke-WebRequest -Headers $Header -Uri $Uri -Method Post  -ContentType "application/json"
                }
                            catch {
                    Write-Error "Failed to update recommendation: $_"
                    return
                }
        }

    }
        catch {
            Write-Error "An unexpected error occurred: $_"
        }
    }
}
