#legger den aktulle storage accounten inn som variablen $context
#Connect-AzAccount
$context = (Get-AzStorageAccount -ResourceGroupName 'resourcegroupname-id-goes-here' -AccountName 'testmigrering1704').context
#Variabel for URI-en
$URL = "https://testmigrering1704.file.core.windows.net/test"


#genererer en SAS-token etter konteksten, på account nivå. -ExpiryTime må defineres for at tok-enen skal vare i mer enn en time.
New-AzStorageAccountSASToken -Context $context -Service Blob,File,Table,Queue -ResourceType Service,Container,Object -Permission racwdlup

#generer en SAS-Token på FIL nivå.
$FileSASToken = New-AzStorageFileSASToken -ShareName "test" -Path "/testfile" -Permission "RWD" -Context $context

#konkatinerer:
$connectionString = $URL+$FileSASToken