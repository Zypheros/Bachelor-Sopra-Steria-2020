Enable-AzVMPSRemoting -Name 'automateTest' -ResourceGroupName 'Bachelor2020Emil' -Protocol https -OsType Windows
Enter-AzVM -name 'automateTest' -ResourceGroupName 'Bachelor2020Emil' -Credential (get-credential)
Disable-AzVMPSRemoting -Name 'automateTest' -ResourceGroupName 'Bachelor2020Emil'