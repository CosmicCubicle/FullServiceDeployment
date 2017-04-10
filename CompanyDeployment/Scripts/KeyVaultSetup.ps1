$CompanyVault = "VaultDemoJerad"
$SetupGroup = "KeyVaultResourceGroup"
$Location = "EastUS"
$DeploymentUser = "Jerad.Berhow@gmail.com"
$SecretDomain = ConvertTo-SecureString "Password1" -AsPlainText -Force
$SecretServer = ConvertTo-SecureString "Password2" -AsPlainText -Force

# Checking for network resource group, creating if does not exist
if (!(Get-AzureRMResourceGroup -Name $setupGroup -ErrorAction SilentlyContinue))
{
    New-AzureRmResourceGroup -Name $SetupGroup -Location $Location
}

#Create Vault
New-AzureRmKeyVault -VaultName $CompanyVault -ResourceGroupName $SetupGroup -Location $location -EnabledForTemplateDeployment

#Setup Domain Secret
Set-AzureKeyVaultSecret -VaultName $CompanyVault -Name $KeyDomain -SecretValue $SecretDomain

#Setup Server Secrets
Set-AzureKeyVaultSecret -VaultName $CompanyVault -Name $KeyServer -SecretValue $SecretServer

#Set Access Policy to allow non-admin account to run deployments using Secrets
Set-AzureRmKeyVaultAccessPolicy -VaultName $CompanyVault -ResourceGroupName $SetupGroup -UserPrincipalName $DeploymentUser -PermissionsToSecrets get -PermissionsToKeys get

Write-Host "Here are the Object IDs you will need:"

$ResourceID = Get-AzureRmKeyVault -VaultName $CompanyVault
$ResourceID.ResourceId
Pause