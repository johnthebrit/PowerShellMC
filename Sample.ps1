#region Basic Pipeline
dir | Sort-Object -Descending

dir | Sort-Object lastwritetime

dir | sort-object –descending –property lastwritetime

#To show the object types being passed
dir | foreach {"$($_.GetType().fullname)  -  $_.name"}  #lazy quick version using alias
Get-ChildItem | ForEach-Object {"$($_.GetType().fullname)  -  $_.name"}  #Proper script version
#endregion


#Region Modules
Get-Module #to see those loaded
Get-Module –listavailable #to see all available
Import-Module <module>  #to add into PowerShell instance
Get-Command –Module <module> #to list commands in a module
Get-Command -Module <module> | Select-Object -Unique Noun | Sort-Object Noun
Get-Command -Module <module> | Select -Unique Noun | Sort Noun  #Lazy version :-)

(Get-Module <module name>).Version  #make sure module has been imported first or will not get output
(Get-Module az.compute).Version
Install-Module Az
Update-Module Az
#endregion


#Region Help
Get-Command –Module <module>
Get-Command –Noun <noun>
Update-Help
#endregion


#region Hello World
Write-Output "Hello World"

#Use a variable
$name = "John"
Write-Output "Hello $name"

#Use an environment variable
Write-Output "Hello $env:USERNAME"
#endregion


#region Connecting Commands

#Looking at variable type
notepad
$proc = Get-Process –name notepad
$proc.GetType().fullname
$proc | Get-Member

get-process | Where-Object {$_.handles -gt 900} | Sort-Object -Property handles |
    ft name, handles -AutoSize

#Must be elevated
Get-WinEvent -LogName security -MaxEvents 10 | Select-Object -Property Id, TimeCreated, Message |
    Sort-Object -Property TimeCreated | convertto-html | out-file c:\sec.html

$xml = [xml](get-content .\R_and_j.xml)
$xml.PLAY
$xml.PLAY.ACT
$xml.PLAY.ACT[0].SCENE[0].SPEECH
$xml.PLAY.ACT.SCENE.SPEECH | Group-Object speaker | Sort-Object count


#Output to file
Get-Process > procs.txt
Get-Process | Out-File procs.txt #what is really happening
get-process | Export-csv c:\stuff\proc.csv
get-process | Export-clixml c:\stuff\proc.xml

#Limiting objects returned
Get-Process | Sort-Object -Descending -Property StartTime | Select-Object -First 5
Get-Process | Measure-Object
Get-Process | Measure-Object WS -Sum

#Comparing
get-process | Export-csv d:\temp\proc.csv
Compare-Object -ReferenceObject (Import-Csv d:\temp\proc.csv) -DifferenceObject (Get-Process) -Property Name

# -confirm and -whatif
get-aduser -filter * | Remove-ADUser -whatif

Get-ADUser -Filter * -Properties "LastLogonDate" `
    | where {$_.LastLogonDate -le (Get-Date).AddDays(-60)} `
    | sort-object -property lastlogondate -descending `
    | Format-Table -property name, lastlogondate -AutoSize

 Get-ADUser -Filter * -Properties "LastLogonDate" `
    | where {$_.LastLogonDate -le (Get-Date).AddDays(-60)} `
    | sort-object -property lastlogondate -descending `
    | Disable-ADAccount -WhatIf

$ConfirmPreference = "medium"
Get-Process | where {$_.name –eq "notepad"} | Stop-Process
$ConfirmPreference = "high"
Get-Process | where {$_.name –eq "notepad"} | Stop-Process


#Using $_

Get-Process | Where-Object {$_.name –eq "notepad"} | Stop-Process

#Simply notation
Get-Process | where {$_.HandleCount -gt 900}
Get-Process | where {$psitem.HandleCount -gt 900}
Get-Process | where HandleCount -gt 900


$UnattendFile = "unattend.xml"
$xml = [xml](gc $UnattendFile)
$child = $xml.CreateElement("TimeZone", $xml.unattend.NamespaceURI)
$child.InnerXml = "Central Standard Time"
$null = $xml.unattend.settings.Where{($_.Pass -eq 'oobeSystem')}.component.appendchild($child)
#$xml.Save($UnattendFile)
$xml.InnerXml

$resources = Get-AzResourceProvider -ProviderNamespace Microsoft.Compute
$resources.ResourceTypes.Where{($_.ResourceTypeName -eq 'virtualMachines')}.Locations


#endregion
