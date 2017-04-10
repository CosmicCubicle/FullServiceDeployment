$Location = "CentralUS"
$TemplateName = "Network"
$CompanyID = "Cosmic"
$EnvironmentName = "d"
$NetworkPrefix = "10.5.5"
$MachineClass = "Standard_DS2"
$P10 = 1
$P20 = 0
$P30 = 0
$SingleMulti = "Single"
$InstanceCount = 1
$ResourceGroup = "rg" + $CompanyID
$DeploymentName = $CompanyID + $EnvironmentName + $TemplateName + "Deployment"
$TemplateUri = "http://storarmtemplates.blob.core.windows.net/templates/" + $TemplateName + ".json"
$DomainName = "CosmicCubicle.net"

$parameters = @{"CompanyID" = $CompanyID;`
                "NetworkPrefix" = $NetworkPrefix;`
                "MachineClass" = $MachineClass;`
                "EnvironmentType" = $EnvironmentName;`
                "DataDiskP10" = $P10;`
                "DataDiskP20" = $P20;`
                "DataDiskP30" = $P30;`
                "InstanceCount"=$InstanceCount;`
                "SingleMulti"= $SingleMulti;`
                "DomainName" = $DomainName
               }  

    ##Catch to verify AzureRM session is active.  Forces sign-in if no session is found
    Write-Output "=> Signing into Azure."
	do {
		$azureAccess = $true
		Try {
			Get-AzureRmSubscription -ErrorAction Stop | Out-Null
		}
		Catch {
			[Microsoft.Online.Administration.Automation.MicrosoftOnlineException]
			$azureAccess = $false
			Write-Warning "Azure authentication error; you're likely not logged in." 
			Write-Verbose $_.Exception
			Login-AzureRmAccount -ErrorAction SilentlyContinue | Out-Null
		}
	} while (! $azureAccess)


# Checking for network resource group, creating if does not exist
if (!(Get-AzureRMResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue))
{
    New-AzureRmResourceGroup -Name $ResourceGroup -Location $Location
}

# Deploying the Template
New-AzureRMResourceGroupDeployment -Name $DeploymentName `
    -ResourceGroupName $ResourceGroup `
    -TemplateUri $TemplateUri `
    -TemplateParameterObject $parameters `
    -Mode Incremental `
    -Verbose
