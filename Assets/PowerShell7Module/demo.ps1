$localpath = "C:\Users\john\OneDrive\projects\PowerShellMC\Assets\PowerShell7Module"
$localpath = "C:\Users\JohnSavill\Documents\Projects\PowerShellMC\Assets\PowerShell7Module"

#Improved compatibility
start-process notepad
get-process | out-gridview -PassThru | stop-process
start-process notepad
Set-Clipboard -Value "Hello from PowerShell" #past into notepad then change notepad and copy
Get-Clipboard

#Module compatibility
Get-pssession
import-module azuread -UseWindowsPowerShell
Get-pssession
Get-module
$c = get-command connect-azuread -module azuread
$c
$c.definition

#foreach -parallel
$nums=(1..10)
Measure-Command {$nums | ForEach-Object {start-sleep -s 1}}
Measure-Command {$nums | ForEach-Object -parallel {start-sleep -s 1} -ThrottleLimit 10 }

#Ternary operator
$path = "c:\dontfind"
(Test-Path $path) ? "Path exists" : "Path not found"
$path = "c:\windows"
(Test-Path $path) ? "Path exists" : "Path not found"

#Pipeline chain
Write-Output 'Hello' && Write-Output 'World'
Write-Error 'Hello' && Write-Output 'World'
Write-Error 'Hello' || Write-Output 'World'
Write-Output 'Hello' || Write-Output 'World'

#null-coalescing
$answer = $null
$answer ?? 42

$answer = "PowerShell"
$answer ?? 42
#can perform actions as well!
{get-module -ListAvailable AzureAD} ?? {Install-Module AzureAD}


$answer = $null
$answer ??= 42
$answer

$answer = "PowerShell"
$answer ??= 42
$answer
#member access
Enable-ExperimentalFeature PSNullConditionalOperators #and restart powershell
Get-ExperimentalFeature
#start notepad
start-process notepad
$process = Get-Process -Name notepad
${process}?.id
get-process notepad | Stop-Process
$process = Get-Process -Name notepad
${process}?.id #won't even try to access the member since the object is null
#element access
$numbers = 1..10
${numbers}?[0]
$numbers = $null
${numbers}?[0] #once again won't try to access

#Better error messages
Get-Childitem -Path c:\nothere
."$localpath\errorscript.ps1"
