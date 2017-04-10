Login-AzureRmAccount
Get-AzureRmSubscription | Ft SubscriptionName,SubscriptionId,State
$SubID = Read-Host "Please paste or type Subscription ID that you wish to manage."
Set-AzureRmContext -SubscriptionId $SubID