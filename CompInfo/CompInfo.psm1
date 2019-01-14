function Get-CompInfo
{
	<#
	.SYNOPSIS
	Gets information about passed servers
	.DESCRIPTION
	Gets information about passed servers using WMI
	.PARAMETER computer
	Names of computers to scan
	.EXAMPLE
	CompInfo.ps1 host1, host2
	Not very interesting
	#>
	[cmdletbinding()]
	Param(
	[Parameter(ValuefromPipeline=$true,Mandatory=$true)][string[]]$computers)
	foreach ($computername in $computers)
	{
	    Write-Verbose "Querying $computername"
	    $lookinggood = $true
	    try
	    {
	        $win32CSOut = Get-CimInstance -ClassName win32_computersystem -ComputerName $computername -ErrorAction Stop
	    }
	    catch
	    {
	        "Something bad: $_"
	        $lookinggood = $false
	    }
	    if($lookinggood)
	    {
	        $win32OSOut = Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computername
	        Write-Debug "Finished querying $computername"

	        $paramout = @{'ComputerName'=$computername;
	        'Memory'=$win32CSOut.totalphysicalmemory;
	        'Free Memory'=$win32OSOut.freephysicalmemory;
	        'Procs'=$win32CSOut.numberofprocessors;
	        'Version'=$win32OSOut.version}

	        $outobj = New-Object -TypeName PSObject -Property $paramout
	        Write-Output $outobj
	    }
	    else
	    {
	        Write-Output "Failed for $computername"
	    }
	}
}