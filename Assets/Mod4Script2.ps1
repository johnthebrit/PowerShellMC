Param(
[Parameter(Mandatory=$true)][string[]]$computers)
foreach ($computername in $computers)
{
    $win32CSOut = Get-CimInstance -ClassName win32_computersystem -ComputerName $computername
    $win32OSOut = Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computername

    $paramout = @{'ComputerName'=$computername;
    'Memory'=$win32CSOut.totalphysicalmemory;
    'Free Memory'=$win32OSOut.freephysicalmemory;
    'Procs'=$win32CSOut.numberofprocessors;
    'Version'=$win32OSOut.version}

    $outobj = New-Object -TypeName PSObject -Property $paramout
    Write-Output $outobj
}
