Param(
[string]$computername='savazuusscdc01')
Get-WmiObject -class win32_computersystem `
	-ComputerName $computername |
	fl numberofprocessors,totalphysicalmemory
