$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$PasswordProfile.Password = "gruppe3GRUPPE!"

New-AzureADUser -DisplayName "WVD tenant" -PasswordProfile $PasswordProfile -UserPrincipalName "username" -AccountEnabled $true -MailNickName "wvdtenant"