#Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host "Installation started"

# create temp folder
$local = "C:\temp"
New-Item -Path $local -ItemType Directory -Force | Out-Null

# Download tools
Write-Host "Started - download..."
Invoke-WebRequest "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeStablePage&Channel=Stable&language=en" -OutFile "$local\MicrosoftEdgeSetup.exe"
Invoke-WebRequest "https://aka.ms/installazurecliwindows" -OutFile "$local\AzureCLI.msi"; 
Invoke-WebRequest "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile "$local\VSCodeSetup-x64.exe"
Invoke-WebRequest "https://aka.ms/vs/16/release/vc_redist.x64.exe" -OutFile "$local\vc_redist.x64.exe"
Invoke-WebRequest "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.20-winx64.msi" -OutFile "$local\mysql-workbench.msi"
Invoke-WebRequest "https://github.com/jjindrich/jjazure-training-az900/raw/master/files/WinSCP-Setup.exe" -OutFile "$local\WinSCP-Setup.exe"
Write-Host "Completed - download..."

# Install tools
Write-Host "Installing tools..."

Write-Host "Installing - CLI..."
Start-Process msiexec.exe -Wait -ArgumentList "/I $local\AzureCLI.msi /quiet"; 
Write-Host "Completed - CLI..."

Write-Host "Installing - VSCode..."
Start-Process "$local\VSCodeSetup-x64.exe" -Wait -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode"
Write-Host "Completed - VSCode..."

Write-Host "Installing - mySql workbench..."
Start-Process "$local\vc_redist.x64.exe" -Wait -ArgumentList "/install /quiet /norestart"
Start-Process "$local\mysql-workbench.msi" -Wait -ArgumentList "/quiet"
Write-Host "Completed - mySql workbench..."

Write-Host "Installing - WinScp..."
Start-Process "$local\WinSCP-Setup.exe" -Wait -ArgumentList "/VERYSILENT /CURRENTUSER"
Write-Host "Completed - WinScp..."

Write-Host "Installing - Edge browser..."
Start-Process "$local\MicrosoftEdgeSetup.exe" -Wait -ArgumentList "-install"
Write-Host "Completed - Edge browser..."

#finish
Write-Host -Verbose 'Installation successfully completed.'