Write-Host 'Number of arguments was :' ($args.Length)
Write-Output 'and they were:'
foreach($arg in $args)
{
    Write-Output $arg
}