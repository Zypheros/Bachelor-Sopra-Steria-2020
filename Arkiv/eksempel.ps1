Param(
        [Parameter(Mandatory=$False)]  
        [string]$RgWhiteListCSV
   )  
 
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
            Add-AzureRMAccount `
            -ServicePrincipal `
            -Tenant $Conn.TenantID `
            -ApplicationId $Conn.ApplicationID `
            -CertificateThumbprint $Conn.CertificateThumbprint


    $RgWhiteList=$RgWhiteListCSV.Split(',',[System.StringSplitOptions]::RemoveEmptyEntries)
   
    $subscriptionName=(Get-AzureRmContext).Subscription.SubscriptionName   

    $rgs = Get-AzureRmResourceGroup | Group-Object -Property ResourceGroupName 
    
    #loop for alerting
    $RgToBeAlerted= ""
    $SendAlertEmailInputParams =@{};
    foreach ($rg in $rgs) {
      
        if($RgWhiteList -notcontains $rg.Name){
         $deploymentForAlert = Get-AzureRmResourceGroupDeployment -ResourceGroupName $rg.Name | Where-Object Timestamp -gt (Get-Date).AddDays(-$NumberOfDaysOfInactivity +1)       
        if($deploymentForAlert -eq $null)
        {
           $RgToBeAlerted = $RgToBeAlerted  +"<li>"+ $rg.Name + "</li><br/> " + "`n"         
        }        
      }
    }
    
    if($RgToBeAlerted -ne "" -And $SendEmailNotification){
		 
		 $MessageBody = "The following resource groups in "+$subscriptionName+" subscription have been <b> inactive since last "+($NumberOfDaysOfInactivity -1)+" day(s)s</b>, hence, will be deleted tomorrow same time if still no deployments are seen:<br/> "  + "`n" + "<ol>"+ $RgToBeAlerted + "</ol>"
		 $SendAlertEmailInputParams.Add("MessageBody", $MessageBody);
		 $SendAlertEmailInputParams.Add("MessageSubject", "FYA: Resource groups scheduled for deletion from "+$subscriptionName+" subscription");
		 $joboutput = Start-AzureRmAutomationRunbook `
                           â€“AutomationAccountName "<Automation account name>" `
                           â€“Name "<Email sending automation>" `
                           -ResourceGroupName "<resource group imported into>" `
                           -Parameters $SendAlertEmailInputParams    
    }
    
    if($RgToBeAlerted -ne ""){
     "Below mentioned resource groups are inactive since last "+($NumberOfDaysOfInactivity -1)+"day(s) `n"+ $RgToBeAlerted -replace "<.*?>" 
    }



    # loop for deleting
    $RgToBeDeleted= ""
    $SendDeletionEmailInputParams =@{};
    $rgsToBeDeleted = Get-AzureRmResourceGroup | Group-Object -Property ResourceGroupName 
    foreach ($rgd in $rgsToBeDeleted) {
      
     if($RgWhiteList -notcontains $rgd.Name){

     # "Searching resource group " + $rg.Name +" with deployments atleast "+ $NumberOfDaysOfInactivity+ " days ago..."

     $deployment = Get-AzureRmResourceGroupDeployment -ResourceGroupName $rgd.Name | Where-Object Timestamp -gt (Get-Date).AddDays(-$NumberOfDaysOfInactivity)

     if($deployment -eq $null)
        {
          # "No recent deployment found, hence delting resource group: " + $rgd.Name
            $RgToBeDeleted = $RgToBeDeleted  +"<li>"+ $rgd.Name + "</li><br/> " + "`n"    
          #  Remove-AzureRmResourceGroup -Name $rgd.Name -Force -Confirm:$false
        }
     
     }
    }
	
  
        
     
      if($RgToBeDeleted -ne "" -And $SendEmailNotification){
           
            $MessageBody = "The following resource groups in "+$subscriptionName+" subscription have been <b> inactive since last "+($NumberOfDaysOfInactivity)+" day(s)s</b>, hence, they have been deleted: <br/> "  + "`n" + "<ol>"+ $RgToBeDeleted + "</ol>"
            $SendDeletionEmailInputParams.Add("MessageBody", $MessageBody);
            $SendDeletionEmailInputParams.Add("MessageSubject", "FYI: Resource groups deleted from "+$subscriptionName+" subscription");
            $joboutput = Start-AzureRmAutomationRunbook `
                              â€“AutomationAccountName "<Automation account name>" `
                              â€“Name "<Email sending automation>" `
                              -ResourceGroupName "<resource group imported into>"  `
                              -Parameters $SendDeletionEmailInputParams  
             "Email notification sent for deleted resource groups"                   
    }
   
    if($RgToBeDeleted -ne ""){
        "`n`nBelow mentioned resource groups have been deleted:`n" +  $RgToBeDeleted -replace "<.*?>" 
    }
    else{       
       "All resource groups optimized. No resources to be deleted. "
     }
           

