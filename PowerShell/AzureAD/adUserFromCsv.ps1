<#
    .DESCRIPTION
    Script som oppretter Azure Active Directory brukere fra en csv fil og gir de en hjemmemappe i form av en fileshare.

    .COMPONENT
    Scriptet trenger en csv-fil med brukernavn for å kunne kjøre. Denne filen må være på formatet "olanormann;karinormann;" for å fungere.
    I tillegg benyttes modulen AzureAD    

    .NOTES
    Author: Endre Aalrust
    LastEdit: 23.04.2020
#>

Connect-AzureAd
Set-AzContext -SubscriptionId "subscription-id-goes-here"

$path = "testCSVFileShare.csv"
Add-Type -Path "C:\Program Files\WindowsPowerShell\Modules\AzureAD\2.0.2.76\Microsoft.Open.AzureAD16.Graph.Client.dll"

$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAd.Model.PasswordProfile
$passwordProfile.Password = "password-goes-here"

Import-Csv $path | Foreach-Object {
    $names = $_.PSObject.Properties
    $strgAccName = $names.Value -split ";"

        foreach ($name in $strgAccName){       
            if(![string]::IsNullOrEmpty($name)){
        
                
                New-AzureADUser `
                    -DisplayName $name `
                    -PasswordProfile $PasswordProfile `
                    -UserPrincipalName "$name@domain-goes-here " `
                    -AccountEnabled $true `
                    -MailNickName $name

                
                Get-AzStorageAccount -ResourceGroupName "resourcegroupname-goes-here" -StorageAccountName "storage-account-goes-here" | `
                New-AzRmStorageShare `
                    -Name $name `
                    -QuotaGiB 250
                
        }        
    }
}