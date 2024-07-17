# PowerShell Module for Microsoft SOC Optimization API

![Logo](./Assets/PSSocOptimization.png)

PowerShell Module for Microsoft SOC optimization API

This PowerShell Module contains PowerShell functions to interact with the Microsoft SOC Optimization API.

## Module Functions

The PSMDSOCOptimization **PowerShell Module** includes the following fuctions:

| Function | Description  |
| ----------------------- | -------------------------------------------------------------------------------------- |
| Get-MDSOCRecommendations | Retrieves the SOC Optimization recommendations |

## Initial Setup and Configuration

1. Register a Microsoft Entra application and record its application ID.
2. Generate and record a client secret for your Microsoft Entra application.
3. Assign your Microsoft Entra application the Microsoft Sentinel contributor role or equivalent.
4. Until the Module is available in the PowerShell Gallery, download the module from the *module* folder and copy the module into your PowerShell module folder.

Prepare a script as shown below and fill in the parameter variables.

## Examples

Retrieve all the recommendations

```powershell
# Import the module
Import-Module -Name "PSMDSOCoptimization" -Force

# ---------------------------------------------------------------------------------- #
# Define the variables for the function
# ---------------------------------------------------------------------------------- #
$AppId = ''
$AppSecret = ''
$TenantName = "demo.OnMicrosoft.com"
$WorkspaceName = ""
$ResourceGroupName = ''
$SubscriptionId = ""

# ---------------------------------------------------------------------------------- #
# Retrieve the recommendations
# ---------------------------------------------------------------------------------- #
$recommendations = Get-MDSOCRecommendations -AppId $AppId -AppSecret $AppSecret -TenantName $TenantName -WorkspaceName $WorkspaceName -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId
$recommendations

```

## References

- [SOC optimization: unlock the power of precision-driven security management](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/soc-optimization-unlock-the-power-of-precision-driven-security/ba-p/4130589)
- [Optimize your security operations](https://learn.microsoft.com/en-us/azure/sentinel/soc-optimization/soc-optimization-access?tabs=azure-portal)
- [Introducing SOC Optimization API](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/introducing-soc-optimization-api/ba-p/4176966)
- [API versions of Microsoft Sentinel REST APIs](https://learn.microsoft.com/en-us/rest/api/securityinsights/api-versions?view=rest-securityinsights-2024-03-01)
