$hostname = (hostname).ToUpper()

Write-Verbose -Verbose:$true "[$hostname] Starting the node configuration"

#Set-ExecutionPolicy unrestricted -Force #This is set automatically when called by Azure script extension

Write-Verbose -Verbose:$true "[$hostname] Enabling Remoting"

Enable-PSRemoting -Force

# uses http://gallery.technet.microsoft.com/scriptcenter/xWebAdministration-Module-3c8bb6be

Write-Verbose -Verbose:$true "[$hostname] Copying content from Azure Files to PowerShell Modules path"

#Copy the modules to the folder
$username = "savillmasterazurestore"
$password = convertto-securestring -String "R6yw==" -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password

New-PSDrive –Name T –PSProvider FileSystem –Root “\\savillmasterazurestore.file.core.windows.net\tools” -Credential $cred
Copy-Item -Path "T:\DSC\xWebAdministration" -Destination $env:ProgramFiles\WindowsPowerShell\Modules -Recurse
Remove-PSDrive -Name T

Write-Verbose -Verbose:$true "[$hostname] Applying DSC Configuration"

$configString=@"
Configuration SavillTechWebsite 
{
    param 
    ( 
        # Target nodes to apply the configuration 
        [string[]]`$NodeName = `'localhost`' 
    ) 
    # Import the module that defines custom resources 
    Import-DscResource -Module xWebAdministration 
    Node `$NodeName 
    { 
        # Install the IIS role 
        WindowsFeature IIS 
        { 
            Ensure          = `"Present`" 
            Name            = `"Web-Server`" 
        } 
        #Install ASP.NET 4.5 
        WindowsFeature ASPNet45 
        { 
          Ensure = `“Present`” 
          Name = `“Web-Asp-Net45`” 
        } 
        # Stop the default website 
        xWebsite DefaultSite  
        { 
            Ensure          = `"Present`" 
            Name            = `"Default Web Site`" 
            State           = `"Stopped`" 
            PhysicalPath    = `"C:\inetpub\wwwroot`" 
            DependsOn       = `"[WindowsFeature]IIS`" 
        } 
        # Copy the website content 
        File WebContent 
        { 
            Ensure          = `"Present`" 
            SourcePath      = `"C:\Program Files\WindowsPowerShell\Modules\xWebAdministration\SavillSite`"
            DestinationPath = `"C:\inetpub\SavillSite`"
            Recurse         = `$true 
            Type            = `"Directory`" 
            DependsOn       = `"[WindowsFeature]AspNet45`" 
        }
        # Create a new website 
        xWebsite SavTechWebSite  
        { 
            Ensure          = '"Present`" 
            Name            = `"SavillSite`"
            State           = `"Started`" 
            PhysicalPath    = `"C:\inetpub\SavillSite`" 
            DependsOn       = `"[File]WebContent`" 
        }
    } 
}
"@
Invoke-Expression $configString 


SavillTechWebsite -MachineName localhost

Start-DscConfiguration -Path .\SavillTechWebsite -Wait -Verbose