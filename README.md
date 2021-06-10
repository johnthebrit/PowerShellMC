# PowerShell Master Class GitHub Repo
## PowerShell Master Class Assets

All content Copyright 2019 John Savill. All rights reserved
No part of this course to be used without express permission from the author
john@savilltech.com
@NTFAQGuy
https://savilltech.com
https://youtube.com/NTFAQGuy

YouTube Playlist for the videos that these materials are for - https://www.youtube.com/playlist?list=PLlVtbbG169nFq_hR7FcMYg32xsSAObuq8

| Module | Additional References |
|--|--|
| [1 PowerShell Fundamentals](https://youtu.be/sQm4zRvvX58) | |
| [2 Connecting Commands](https://youtu.be/K_LsLq5yGgk) | |
| [3 Remote Management](https://youtu.be/PMRkM9jlMMw) | |
| [Getting ready for DevOps](https://youtu.be/yavDKHV-OOI) | |
| [4 Creating a PowerShell Script](https://youtu.be/sQm4zRvvX58) |[Azure PowerShell](https://youtu.be/RQMdJ-9-lxY) <br> [Using Try-Catch](https://youtu.be/2eByC9N1xIQ) <br>[Debug PowerShell](https://youtu.be/2cpU82i6YPU)|
| [5 Advanced Scripting](https://youtu.be/BVU7MxlyMmA) | |
| [6 Data and Objects](https://youtu.be/Bmsa6F69afA) | |
| [7 Desired State Configuration](https://youtu.be/D-jmIk4xaWw) | |
| [8 Automation Technologies](https://youtu.be/n2dlNA3Z-mc) | [Azure Functions with PowerShell](https://youtu.be/fIycfLlgph0) <br> [Azure Functions with PowerShell 2](https://youtu.be/0e2WlHCulZE)|
| [PowerShell 7](https://youtu.be/K9EUntTP7jM) | |

## Getting a Clone
Once Git is installed to have a local clone of the repository:

```sh
New-Item -ItemType Directory -Path C:\PowerShellMC
cd c:\PowerShellMC
git clone https://github.com/johnthebrit/PowerShellMC.git .
```

To update, make sure you are in the folder downloaded to and run

```sh
git pull
```

## Useful Links and Info

| Feature             | Link                                      |
|---------------------|-------------------------------------------|
| PowerShell Core     | https://github.com/powershell/powershell  |
| Visual Studio Code  | https://code.visualstudio.com/Download    |
| Git                 | https://git-scm.com/downloads             |

Chocolatey Install

```sh
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Chocolately PowerShell Core upgrade -

```sh
Choco outdated
Choco upgrade powershell-core
```

## References

Windows PowerShell Compatibility - https://github.com/PowerShell/WindowsCompatibility

Installing PowerShell Core on Ubuntu - https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1804

Installing VS Core on Ubuntu - https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
https://www.ubuntu18.com/install-visual-studio-code-ubuntu-18/

Setting up SSH - https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core?view=powershell-6

Secrets of PowerShell Remoting eBook - https://leanpub.com/secretsofpowershellremoting
