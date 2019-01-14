Param(
[string]$computername='savazuusscdc01')
Get-CimInstance -ClassName win32_computersystem `
	-ComputerName $computername |
	fl numberofprocessors,totalphysicalmemory
