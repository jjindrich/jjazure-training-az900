#Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host "Installation started"

# create temp folder
$local = "C:\temp"
New-Item -Path $local -ItemType Directory -Force | Out-Null

# Download tools
Write-Host "Started - download..."

$data = @(
       [pscustomobject]@{Name="Edge";Url="https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeStablePage&Channel=Stable&language=en";OutputFile="$local\MicrosoftEdgeSetup.exe"}
       [pscustomobject]@{Name="CLI";Url="https://aka.ms/installazurecliwindows";OutputFile="$local\AzureCLI.msi"}
       [pscustomobject]@{Name="VSCode";Url="https://go.microsoft.com/fwlink/?Linkid=852157";OutputFile="$local\VSCodeSetup-x64.exe"}
       [pscustomobject]@{Name="VCRedist";Url="https://aka.ms/vs/16/release/vc_redist.x64.exe";OutputFile="$local\vc_redist.x64.exe"}
       [pscustomobject]@{Name="MySQLWorkbench";Url="https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.20-winx64.msi";OutputFile="$local\mysql-workbench.msi"}
       [pscustomobject]@{Name="WinSCP";Url="https://github.com/jjindrich/jjazure-training-az900/raw/master/files/WinSCP-Setup.exe";OutputFile="$local\WinSCP-Setup.exe"}
   )

$data | ForEach-Object {

$out = $_.OutputFile;
$name = $_.Name;
$url = $_.Url;

    $jobDefinition = {
            cd $using:local
            Invoke-WebRequest -Uri $using:url -OutFile $using:out
      }

    Start-Job $jobDefinition -Name $name;
}

#Wait for all jobs
Get-Job | Wait-Job

Get-Job | Remove-Job

Write-Host ""

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
