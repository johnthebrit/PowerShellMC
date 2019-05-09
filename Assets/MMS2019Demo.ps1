#dir | sort from cmd.exe
dir | Sort-Object -Descending
dir | Sort-Object lastwritetime

$PSVersionTable
$IsWindows
$IsLinux

https://github.com/powershell/powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" #One line install

#Install using Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco upgrade powershell-core

#Check compatibility
get-module -ListAvailable –SkipEditionCheck
https://devblogs.microsoft.com/powershell/the-next-release-of-powershell-powershell-7/ #changing in next release

#Compat module
Get-eventlog #fails
Install-Module WindowsCompatibility -Scope CurrentUser
Import-WinModule Microsoft.PowerShell.Management
Get-EventLog -Newest 5 -LogName “security“
Get-WinEvent -LogName security -MaxEvents 5 #native core options

$c = get-command get-eventlog
$c
$c.definition
get-pssession #see the wincompat session to local

#GIT config
git config --global user.email "john@savilltech.com“
git config --global user.name "johnthebrit“
git config --list