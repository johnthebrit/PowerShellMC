#region Basic Pipeline
dir | Sort-Object -Descending

dir | Sort-Object lastwritetime

dir | sort-object –descending –property lastwritetime

dir | foreach {"$($_.GetType().fullname)  -  $_.name"}
#endregion



#region Hello World
Write-Output "Hello World"

$name = "John"
Write-Output "Hello $name"

Write-Output "Hello $env:USERNAME"
#endregion