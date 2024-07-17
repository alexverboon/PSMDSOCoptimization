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

```PowerShell
Output

Id                   : 
name                 : 
type                 : Microsoft.SecurityInsights/Recommendations
properites           : @{recommendationTypeId=Precision_Coverage; state=Active; title=Coverage improvement against AiTM (Adversary in the Middle); description=We 
                       discovered that you can improve your coverage against AiTM (Adversary in the Middle).; creationTimeUtc=2024-01-14T13:19:38.8747624+00:00; 
                       lastEvaluatedTimeUtc=2024-05-30T23:42:56.8728235+00:00; lastModifiedTimeUtc=2024-01-14T13:19:38.8747624+00:00; suggestions=System.Object[]; 
                       additionalProperties=}
state                : Active
title                : Coverage improvement against AiTM (Adversary in the Middle)
description          : We discovered that you can improve your coverage against AiTM (Adversary in the Middle).
creationTimeUtc      : 2024-01-14T13:19:38.8747624+00:00
lastEvaluatedTimeUtc : 2024-05-30T23:42:56.8728235+00:00
lastModifiedTimeUtc  : 2024-01-14T13:19:38.8747624+00:00
suggestions          : {@{suggestionTypeId=Precision_Coverage_ImproveCoverage; title=Improve coverage; description=Improve your coverage against AiTM (Adversary in 
                       the Middle) attacks from Low to High.; action=Go to content hub and add 26 new analytic rules. You can also create your own rule to achieve 
                       the recommended level of coverage.; additionalProperties=}}
additionalProperties : @{UseCaseId=attackscenario--22b9ed35-6525-40c9-a1d4-a7edefaf0fd9; UseCaseName=AiTM (Adversary in the Middle)}
```

## References

- [SOC optimization: unlock the power of precision-driven security management](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/soc-optimization-unlock-the-power-of-precision-driven-security/ba-p/4130589)
- [Optimize your security operations](https://learn.microsoft.com/en-us/azure/sentinel/soc-optimization/soc-optimization-access?tabs=azure-portal)
- [Introducing SOC Optimization API](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/introducing-soc-optimization-api/ba-p/4176966)
- [API versions of Microsoft Sentinel REST APIs](https://learn.microsoft.com/en-us/rest/api/securityinsights/api-versions?view=rest-securityinsights-2024-03-01)
