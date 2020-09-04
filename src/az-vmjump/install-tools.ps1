#Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Write-Host "Starting installation"

# create temp
New-Item -Path 'C:\temp' -ItemType Directory -Force | Out-Null
$local = "C:\temp"

# install Edge
$Edge = {
    Invoke-WebRequest "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeStablePage&Channel=Stable&language=en" -OutFile "$using:local\MicrosoftEdgeSetup.exe"
    cd $using:local
    .\MicrosoftEdgeSetup.exe
  }

$EdgeJob = Start-Job $Edge -ArgumentList $_ -Name "Edge"

$null = Register-ObjectEvent $EdgeJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'Edge installed'

        Write-Host | Receive-Job
 
        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

# install Azure CLI
$AzureCLI = {
    Invoke-WebRequest "https://aka.ms/installazurecliwindows" -OutFile "$using:local\AzureCLI.msi"; 
    cd $using:local
    Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; 
  }

$AzureCLIJob = Start-Job $AzureCLI -ArgumentList $_ -Name "AzureCLI"

$null = Register-ObjectEvent $AzureCLIJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'AzureCLI installed'

        Write-Host | Receive-Job
 
        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

# install VSCode
$VSCode = {
    Invoke-WebRequest "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile "$using:local\VSCodeSetup-x64.exe"
    cd $using:local
    .\VSCodeSetup-x64.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode code --install-extension msazurermtools.azurerm-vscode-tools
  }

$VSCodeJob = Start-Job $VSCode -ArgumentList $_ -Name "VSCode"

$null = Register-ObjectEvent $VSCodeJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'VSCode installed'

        Write-Host | Receive-Job
 
        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

#install VCRedist
$VcRedist = {
    Invoke-WebRequest "https://aka.ms/vs/16/release/vc_redist.x64.exe" -OutFile "$using:local\vc_redist.x64.exe"
    cd $using:local
    .\vc_redist.x64.exe /install /quiet /norestart 
  }

$VcRedistJob = Start-Job $VcRedist -ArgumentList $_ -Name "VcRedist"

$null = Register-ObjectEvent $VcRedistJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'VcRedist installed'

        Write-Host | Receive-Job
 
        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

# install mySql workbench
$MySQLWorkbench = {
    Invoke-WebRequest "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.20-winx64.msi" -OutFile "$using:local\mysql-workbench.msi"
    cd $using:local
    .\mysql-workbench.msi /quiet
  }

$MySQLWorkbenchJob = Start-Job $MySQLWorkbench -ArgumentList $_ -Name "MySQLWorkbench"

$null = Register-ObjectEvent $MySQLWorkbenchJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'MySQLWorkbench installed'
 
        Write-Host | Receive-Job

        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

# install WinScp
$WinSCP = {
    Invoke-WebRequest "https://sourceforge.net/projects/winscp/files/WinSCP/5.17.7/WinSCP-5.17.7-Setup.exe/download" -OutFile "$using:local\WinSCP-Setup.exe"
 #   cd $using:local
 #   .\WinSCP-Setup.exe /VERYSILENT /CURRENTUSER
  }

$WinSCPJob = Start-Job $WinSCP -ArgumentList $_ -Name "WinSCP"

$null = Register-ObjectEvent $WinSCPJob -EventName StateChanged -Action {
    if ($eventArgs.JobStateInfo.State -eq [System.Management.Automation.JobState]::Completed)
    {
        Write-Host -ForegroundColor Green 'WinSCP installed'

        Write-Host | Receive-Job
 
        # This command removes the original job
        $sender | Remove-Job -Force
 
        # These commands remove the event registration
        $eventSubscriber | Unregister-Event -Force
        $eventSubscriber.Action | Remove-Job -Force
    }
}

Write-Verbose -Verbose 'Current state:'
 
Get-Job | Out-Host

While (Get-Job -State "Running")
{
  Start-Sleep 10
}

Write-Information -Verbose 'All completed'
# troubleshooting
# Get-Job | Receive-Job