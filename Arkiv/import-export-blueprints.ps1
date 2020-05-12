#######################
##   Get Azure info  ##
#######################

$SubscriptionName = 'Azure for studenter'
$SubscriptionId = (Get-AzSubscription `
    -SubscriptionName $SubscriptionName).id

$localPath = "C:\Users\endre\Documents\GitHub\Bachelor2020\Blueprints\Governance"


###############################################
##   Import blueprint to Azure Subscription  ##
###############################################

Import-AzBlueprintWithArtifact -Name "Governance" -SubscriptionId $SubscriptionId -InputPath  $localPath -Verbose
