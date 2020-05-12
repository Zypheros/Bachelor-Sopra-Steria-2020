<#

    .SYNOPSIS
        Script som migerer en MySQl database fra en virtuell maskin på Hyper-V over til Azure Database for MySQL

    .DESCRIPTION
        * Sjekker først om Hyper-V modulen er installert, hvis ikke blir den installert.
        * Oppretter MigrateAppliance.vdhx med 85GB lagringsplass.
        * Oppretter MigrateApplianceVm med 16GB ram
        * Kobler opp MigrateAppliance.vdhx til MigrateApplianceVM
        * Kobler opp en windows-iso fil til MigrateApplianceVM
        * Setter antall prosessorer på MigrateApplianceVm til å være lik 8, og spesifiserer vektbalanse på 
          fysisk server i forhold til resurssbruk   

    .NOTES
        AUTHOR: Emil Brasø
        LASTEDIT: March 05.03.2020   
#>

