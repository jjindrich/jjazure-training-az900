# Documentation
# https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis

# Install IIS
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures

# Install ASP.NET Core Runtime Windows Hosting Bundle Installer
# https://dotnet.microsoft.com/download/dotnet-core
Invoke-WebRequest "https://download.visualstudio.microsoft.com/download/pr/ba001109-03c6-45ef-832c-c4dbfdb36e00/e3413f9e47e13f1e4b1b9cf2998bc613/dotnet-hosting-2.2.8-win.exe" -OutFile dotnet-hosting-2.2.8-win.exe
.\dotnet-hosting-2.2.8-win.exe /silent
