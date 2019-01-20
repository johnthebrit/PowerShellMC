#region Module 1 - PowerShell Fundamentals

#Basic Pipeline
dir | Sort-Object -Descending

dir | Sort-Object lastwritetime

dir | sort-object –descending –property lastwritetime

#To show the object types being passed
dir | foreach {"$($_.GetType().fullname)  -  $_.name"}  #lazy quick version using alias
Get-ChildItem | ForEach-Object {"$($_.GetType().fullname)  -  $_.name"}  #Proper script version

#Modules
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


#Help
Get-Command –Module <module>
Get-Command –Noun <noun>
Update-Help

#Hello World
Write-Output "Hello World"

#Hello Universe
Write-Output "Hello Universe"

#Use a variable
$name = "John"
Write-Output "Hello $name"

#Use an environment variable
Write-Output "Hello $env:USERNAME"

#endregion


#region Module 2 - Connecting Commands

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

#PowerShell Core or Windows PowerShell
Get-WinEvent -LogName security -MaxEvents 5
Invoke-Command -ComputerName savazuusscdc01, savazuusedc01 `
    -ScriptBlock {get-winevent -logname security -MaxEvents 5}

#Windows PowerShell only
Get-EventLog -LogName Security -newest 10
Invoke-command -ComputerName savdaldc01,savdalfs01,localhost `
    -ScriptBlock {Get-EventLog -LogName Security -newest 10}


#Comparing
get-process | Export-csv d:\temp\proc.csv
Compare-Object -ReferenceObject (Import-Csv d:\temp\proc.csv) -DifferenceObject (Get-Process) -Property Name

notepad
$procs = get-process
get-process -Name notepad | Stop-Process
$procs2 = get-process
Compare-Object -ReferenceObject $procs -DifferenceObject $procs2 -Property Name


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
notepad
Get-Process | where {$_.name –eq "notepad"} | Stop-Process
notepad
get-process | where {$_.name -eq "notepad"} | stop-process -confirm:$false
$ConfirmPreference = "high"
Get-Process | where {$_.name –eq "notepad"} | Stop-Process


#Using $_

Get-Process | Where-Object {$_.name –eq "notepad"} | Stop-Process

#Simply notation
Get-Process | where {$_.HandleCount -gt 900}
Get-Process | where {$psitem.HandleCount -gt 900}
Get-Process | where HandleCount -gt 900
Get-Process | ? HandleCount -gt 900


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


#region Module 3 - Remote Management

#enabling WinRM and PS Remoting
Enable-PSRemoting

Invoke-Command -ComputerName savazuusscdc01 {$env:computername}
Invoke-Command -ComputerName savazuusscds01 {$var=10}
Invoke-Command -ComputerName savazuusscds01 {$var}

#Filter on remote and perform actions or strange results
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {get-eventlog -logname security} | select-object -First 10
Invoke-command -computername savazuusscdc01 -scriptblock {get-eventlog -logname security | select-object -first 10}
Invoke-command -computername savazuusscdc01 -scriptblock {get-eventlog -logname security -newest 10}

Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {get-process} | where {$_.name -eq "notepad"} | Stop-Process
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {get-process | where {$_.name -eq "notepad"} | Stop-Process }

Measure-Command {Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {get-process} | where {$_.name -eq "notepad"} }
Measure-Command {Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {get-process | where {$_.name -eq "notepad"}} }


#Sessions
$session = New-PSSession -ComputerName savazuusscds01
Invoke-Command -SessionName $session {$var=10}
Invoke-Command -SessionName $session {$var}
Enter-PSSession -Session $session  #also interactive
Get-PSSession
$session | Remove-PSSession

#Multiple machines
$dcs = "savazuusedc01", "savazuusscdc01"
Invoke-Command -ComputerName $dcs -ScriptBlock {$env:computername}
$sess = New-PSSession -ComputerName $dcs
$sess
icm –session $sess –scriptblock {$env:computername}

#Implicit remoting
$adsess = New-PSSession -ComputerName savazuusscdc01
Import-Module -Name ActiveDirectory -PSSession $adsess
Get-Module #type different from the type on the actual DC
Get-Command -Module ActiveDirectory #functions instead of cmdlets
Get-ADUser -Filter *
$c = Get-Command Get-ADUser
$c.Definition
Remove-Module ActiveDirectory
Import-Module -Name ActiveDirectory -PSSession $adsess -Prefix OnDC
Get-Command -Module ActiveDirectory
Get-OnDCADUser -Filter *  #I don't have regular Get-ADUser anymore

#Execution operator &
$comm = "get-process"
$comm   #Nope
&$comm  #Yep!


#PowerShell Core Compatibility with Windows PowerShell modules
get-module -ListAvailable -SkipEditionCheck
Get-EventLog  #Fails in PowerShell Core
Install-Module WindowsCompatibility -Scope CurrentUser
Import-WinModule Microsoft.PowerShell.Management
Get-EventLog -Newest 5 -LogName "security"
#Behind the scenes
$c = Get-Command get-eventlog
$c
$c.definition
Get-PSSession #Note the WinCompat session to local machine


#Alternate endpoint
Enable-WSManCredSSP -Role "Server" -Force
New-PSSessionConfigurationFile –ModulesToImport OneTech, ActiveDirectory, Microsoft.PowerShell.Utility `
	–VisibleCmdLets ('*OneTech*','*AD*','format*','get-help') `
	-VisibleFunctions ('TabExpansion2') -VisibleAliases ('exit','ft','fl') –LanguageMode ConstrainedLanguage `
	-VisibleProviders FileSystem `
	–SessionType ‘RestrictedRemoteServer’ –Path ‘c:\dcmonly.pssc’
Register-PSSessionConfiguration -Name "DCMs" -Path C:\dcmonly.pssc -StartupScript C:\PSData\DCMProd.ps1

$pssc = Get-PSSessionConfiguration -Name "DCMs"
$psscSd = New-Object System.Security.AccessControl.CommonSecurityDescriptor($false, $false, $pssc.SecurityDescriptorSddl)

$Principal = "savilltech\DCMs"
$account = New-Object System.Security.Principal.NTAccount($Principal)
$accessType = "Allow"
$accessMask = 268435456
$inheritanceFlags = "None"
$propagationFlags = "None"
$psscSd.DiscretionaryAcl.AddAccess($accessType,$account.Translate([System.Security.Principal.SecurityIdentifier]),$accessMask,$inheritanceFlags,$propagationFlags)
Set-PSSessionConfiguration -Name "DCMs" -SecurityDescriptorSddl $psscSd.GetSddlForm("All") -Force
#Set-PSSessionConfiguration -Name "DCMs" -ShowSecurityDescriptorUI
Restart-Service WinRM


#Enabling HTTPS
Winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="host";CertificateThumbprint="thumbprint"}
#e.g.
cd Cert:\LocalMachine\My
Get-ChildItem #or ls remember. Find the thumbprint you want
winrm create winrm/config/listener?address=*+Transport=HTTPS @{Hostname="savazuusscdc01.savilltech.net";CertificateThumbprint="B4B3FAE3F30944617E477F77756D6ABCB9980E38"}
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

#To view - must be elevated
winrm enumerate winrm/config/Listener

#Connect using SSL
Invoke-Command savazuusscdc01.savilltech.net -ScriptBlock {$env:computername} -UseSSL
#Short name will fail as using cert can override
$option = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
Enter-PSSession -ComputerName savazuusscdc01 -SessionOption $option -useSSL

#Connection via SSH  hostname instead of computername
Invoke-Command -HostName savazuussclnx01 -ScriptBlock {get-process} -UserName john

#Mix of WinRM and SSH
New-PSSession -ComputerName savazuusscds01  #winrm
New-PSSession -HostName savazuussclnx01 -UserName john
Get-PSSession -OutVariable sess
$sess
invoke-command $sess {get-process *s}
$sess | Remove-PSSession

#endregion


#region Module 4 - PowerShell Scripting

#Shows write-host vs write-output
function Receive-Output
{
    process { write-host $_ -ForegroundColor Green}
}
Write-Output "this is a test" | Receive-Output
Write-Host "this is a test" | Receive-Output
Write-Output "this is a test"

#' vs "
$name = "John"
Write-Output "Hello $name"
Write-Output 'Hello $name'
$query = "SELECT * FROM OS WHERE Name LIKE '%SERVER%'"
Write-Output "Hello `t`t`t World"

#User input
$name = Read-Host "Who are you?"
$pass = Read-Host "What's your password?" -AsSecureString
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))


Get-CimInstance -ClassName Win32_Logical  #ctrl space to intelli sense all the name spaces available

#endregion


#region Module 5 - Advanced PowerShell Scripting

function first3 {$input | Select-Object -First 3}
get-process | first3

#Code signing
$cert = @(gci cert:\currentuser\my -codesigning)[0]
Set-AuthenticodeSignature signme.ps1 $cert

#endregion


#region Module 6 - Parsing Data and Working With Objects

#Credentials
#This is not good
$user = "administrator"
$password = 'Pa55word'
$securePassword = ConvertTo-SecureString $password `
    -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)

#An encrypted string
$encryptedPassword = ConvertFrom-SecureString (ConvertTo-SecureString -AsPlainText -Force "Password123")
$securepassword = ConvertTo-SecureString "<the huge value from previous command>"

#Another file
$credpath = "c:\temp\MyCredential.xml"
New-Object System.Management.Automation.PSCredential("john@savilltech.com", (ConvertTo-SecureString -AsPlainText -Force "Password123")) | Export-CliXml $credpath
$cred = import-clixml -path $credpath

#Using Key Vault
Select-AzSubscription -Subscription (Get-AzSubscription | where Name -EQ "SavillTech Dev Subscription")
$cred = Get-Credential

#Store username and password in keyvault
Set-AzKeyVaultSecret -VaultName 'SavillVault' -Name 'SamplePassword' -SecretValue $cred.Password
$secretuser = ConvertTo-SecureString $cred.UserName -AsPlainText -Force #have to make a secure string
Set-AzKeyVaultSecret -VaultName 'SavillVault' -Name 'SampleUser' -SecretValue $secretuser

#Getting back
$username = (get-azkeyvaultsecret -vaultName 'SavillVault' -Name 'SampleUser').SecretValueText
$password = (get-azkeyvaultsecret -vaultName 'SavillVault' -Name 'SamplePassword').SecretValue
(get-azkeyvaultsecret -vaultName 'SavillVault' -Name 'SamplePassword').SecretValueText #Can get the plain text via key vault
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)) #Inspect if want to double check

#Recreate
$newcred = New-Object System.Management.Automation.PSCredential ($username, $password)
#Test
invoke-command -ComputerName savazuusscdc01 -Credential $newcred -ScriptBlock {whoami}

#Var types
$number=42
$boolset=$true
$stringval="hello"
$charval='a'
$number.GetType()
$boolset.GetType()
$stringval.GetType()
$charval.GetType()

[char]$newchar= 'a'
$newchar.GetType()

42 –is [int]

$number = [int]42
$number.ToString() | gm

$string1 = "the quick brown fox jumped over the lazy dog"
$string1 -like "*fox*"
$string2 = $string1 + " who was not amused"


#Time
$today=Get-Date
$today | Select-Object –ExpandProperty DayOfWeek
[DateTime]::ParseExact("02-25-2011","MM-dd-yyyy",[System.Globalization.CultureInfo]::InvariantCulture)
$christmas=[system.datetime]"25 December 2019"
($christmas - $today).Days
$today.AddDays(-60)
$a = new-object system.globalization.datetimeformatinfo
$a.DayNames

#Variable Scope
function test-scope()
{
    write-output $defvar
    write-output $global:globvar
    write-output $script:scripvar
    write-output $private:privvar
    $funcvar = "function"
    $private:funcpriv = "funcpriv"
    $global:funcglobal = "globfunc"
}

$defvar = "default/local" #default
get-variable defvar -scope local
$global:globvar = "global"
$script:scripvar = "script"
$private:privvar = "private"
test-scope
$funcvar
$funcglobal #this should be visible

#Variables with Invoke-Command
$message = "Message to John"
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Host $message}

$ScriptBlockContent = {
    param ($MessageToWrite)
    Write-Host $MessageToWrite }
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock $ScriptBlockContent -ArgumentList $message
#or
Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Output $args} -ArgumentList $message

Invoke-Command -ComputerName savazuusscdc01 -ScriptBlock {Write-Host $using:message}


#Hash Tables
$favthings = @{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}
$favthings.Add("John","Crab Cakes")
$favthings.Set_Item("John","Steak")
$favthings.Get_Item("Abby")

#Custom objects
$cusobj = New-Object PSObject
Add-Member -InputObject $cusobj -MemberType NoteProperty `
    -Name greeting -Value "Hello"

$favthings = @{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}
$favobj = New-Object PSObject -Property $favthings
#In PowerShell v3 can skip a step
$favobj2 = [PSCustomObject]@{"Julie"="Sushi";"Ben"="Trains";"Abby"="Princess";"Kevin"="Minecraft"}


#Foreach
$names = @("Julie","Abby","Ben","Kevin")
$names | ForEach-Object -Process { Write-Output $_}
$names | ForEach -Process { Write-Output $_}
$names | ForEach { Write-Output $_}
$names | % { Write-Output $_}

#Foreach vs Foreach
ForEach-Object -InputObject (1..100) {
    $_
} | Measure-Object

ForEach ($num in (1..100)) {
    $num
} | Measure-Object

'Z'..'A'

#Accessing property values
$samacctname = "John"
Get-ADUser $samacctname  -Properties mail
Get-ADUser $samacctname  -Properties mail | select-object mail
Get-ADUser $samacctname  -Properties mail | select-object mail | get-member
Get-ADUser $samacctname  -Properties mail | select-object -ExpandProperty mail | get-member
Get-ADUser $samacctname  -Properties mail | select-object -ExpandProperty mail


#endregion


#region Module 7 - Desired State Configuration

#Imperative install
Import-Module ServerManager
#Check and install Web Server Role if not installed
If (-not (Get-WindowsFeature "Web-Server").Installed)
{
    try {
        Add-WindowsFeature Web-Server
    }
    catch {
        Write-Error $_
    }
}

#Get all providers
Get-DscResource

#endregion


#region Module 8 - Automation Technologies

#Short workflow
Workflow MyWorkflow {Write-Output "Hello from Workflow!"}
MyWorkflow

#Long workflow
Workflow LongWorkflow
{
Write-Output -InputObject "Loading some information..."
  Start-Sleep -Seconds 10
  CheckPoint-Workflow
  Write-Output -InputObject "Performing process list..."
  Get-process -PSPersist $true #this adds checkpoint
  Start-Sleep -Seconds 10
  CheckPoint-Workflow
  Write-Output -InputObject "Cleaning up..."
  Start-Sleep -Seconds 10

}
LongWorkflow –AsJob –JobName LongWF –PSPersist $true
Suspend-Job LongWF
Get-Job LongWF
Receive-Job LongWF –Keep
Resume-Job LongWF
Get-Job LongWF
Receive-Job LongWF –Keep
Remove-Job LongWF #removes the saved state of the job

#Parallel execution
workflow paralleltest
{
    parallel
    {
        get-process -Name w*
        get-process -Name s*
        get-service -name x*
        get-eventlog -LogName Application -newest 10
    }
}
paralleltest

workflow compparam
{
   param([string[]]$computers)
   foreach –parallel ($computer in $computers)
   {
        Get-CimInstance –Class Win32_OperatingSystem –PSComputerName $computer
        Get-CimInstance –Class win32_ComputerSystem –PSComputerName $computer
   }
}
compparam -computers savazuusscdc01, savazuusedc01

#Parallel and Sequence
workflow parallelseqtest
{
    parallel
    {
        sequence
        {
            get-process -Name w*
            get-process -Name s*
        }
        get-service -name x*
        get-eventlog -LogName Application -newest 10
    }
}
parallelseqtest

Workflow RestrictionCheck
{
    $msgtest = "Hello"
    #msgtest.ToUpper()
    $msgtest = InlineScript {($using:msgtest).ToUpper()}
    Write-Output $msgtest
}
RestrictionCheck

#Calling a function
$FunctionURL = "<your URI>"
Invoke-RestMethod -Method Get -Uri $FunctionURL

Invoke-RestMethod -Method Get -Uri "$($FunctionURL)&name=John"

$JSONBody = @{name = "World"} | ConvertTo-Json
Invoke-RestMethod -Method Post -Body $JSONBody -Uri $FunctionURL
#endregion