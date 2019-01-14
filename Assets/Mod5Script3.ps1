Param(
[Parameter(Mandatory=$true)][string]$computername,[switch]$showlogprocs)
if($showlogprocs)
{
    Get-CimInstance -class win32_computersystem -ComputerName $computername `
    | fl NumberOfLogicalProcessors,totalphysicalmemory
}
else
{
    Get-CimInstance -class win32_computersystem -ComputerName $computername `
    | fl numberofprocessors,totalphysicalmemory
}
