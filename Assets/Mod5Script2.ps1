Param([Parameter(Mandatory=$True,Position=2)][String]$Name,
 [Parameter(Mandatory=$True,Position=1)][String]$Greeting)
Write-Host $Greeting $Name
