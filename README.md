# JJ Azure training for AZ-900 certification

## Azure fundamentals

Official training [Azure Learn Azure fundamentals](https://docs.microsoft.com/learn/paths/azure-fundamentals)

You will get necessary knowledge to take the [AZ900 Microsoft Azure Fundamentals Exam](https://www.microsoft.com/learning/exam-AZ-900.aspx).

## Azure fundamentals labs

List of labs

- Virtual Machines https://docs.microsoft.com/en-us/learn/modules/intro-to-azure-virtual-machines/
- WebApp https://docs.microsoft.com/en-us/learn/modules/host-a-web-app-with-azure-app-service/
- Containers https://docs.microsoft.com/en-us/learn/paths/administer-containers-in-azure/
- Serverless https://docs.microsoft.com/en-us/learn/paths/create-serverless-applications/

## Explore Azure Portal

Check Azure Portal setting

- change language
- portal menu to Docked

Check Azure Cloud Shell icon

- run command az
- upload file

Customize Azure Dashboard

- pin resource group
- pin graph/query from Azure Monitor
- share dashboard

## Azure advanced lab

### Deploy Windows jump server

This Windows jump server will be our workstation for next steps in this lab.

Deploy new Windows Server 2019 as workstation

- use Azure portal - create new server with public IP address
- use following script

```bash
az group create -n rg-co-vmjump -l westeurope
az vm create -n covmjump -g rg-co-vmjump --image win2019datacenter --admin-username azureuser
```

Connect into jump server using RDP.

Download this repository and extract it

```powershell
cd .\Documents\
Invoke-WebRequest "https://github.com/jjindrich/jjazure-training-az900/archive/master.zip" -OutFile app.zip
```

Install Edge browser, Azure CLI, VS Code with ARM extension, MySql Workbench, WinScp, Windows Terminal into your Azure workstation.

Script is prepared for automated installation, open PowerShell as administrator and run following

```powershell
cd .\app\jjazure-training-az900-master\src\az-vmjump\
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
.\install-tools.ps1
```

*Reopen Windows Powershell to apply new PATH settings.*

Check Azure CLI on your jump virtual server

```powershell
az vm list
```

Run Visual Studio Code and open downloaded repository and check the structure.

**Advanced scenarios**

- provision Azure Bastion server to access Windows server with HTTPS
- use Virtual Machine Managed Identity to access Azure resource (instead using your credentials) and run "az login --identity"

### Deployment schema

![Schema](/media/schema.png)

### Explore application source code

Web application Movie App List

- dotNet ASP.Net Core 2.2 webapp with mySql database
- Source code - [movie-app-list](/src/movie-app-list)
- configuration - [appsettings.json](/src/movie-app-list/appsettings.json)
- compiled binaries - [movie-app-list](/bin/movie-app-list)

### Deploy application to Azure infrastructure services

This section deploys web application part to Azure Virtual Machine.
You can use scripts to speed up deployment.

**Prepare networking** with Azure Portal

- create new resource group for networking rg-co-network
- create new virtual network vnet-comain 10.10.0.0/16 with subnets snet-comain-web 10.10.1.0/24 and snet-comain-db 10.10.2.0/24
- peer network vnet-comain with your jump server network

or use ARM script (peering is not scripted)

```bash
cd src/az-networking
az group create -n rg-co-network -l westeurope
az deployment group create -n Network -g rg-co-network --template-file deploy.json --parameters deploy.params.json
```

Check ARM basics https://github.com/azurecz/azuretechacademy-hybridit-labs-day2#arm-template-basics

**Deploy web application** with Azure Portal

- create new Windows 2019 virtual machine covmwebwin in resource group rg-co-vmwebwin *without publicIP and no public ports* network vnet-comain
- create new Ubuntu 18.04 virtual machine covmweblx in resource group rg-co-vmweblx *without publicIP and no public ports* network vnet-comain
- install application on Windows - https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis
    1. install IIS and ASP.NET Core Runtime Windows Hosting Bundle Installer version 2.2
    2. create new IIS site and Application Pool (No Managed Code)
    3. copy application from bin/movie-app-list to IIS site folder
- install application on Linux (Ubuntu) - https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx
    1. copy application from bin/movie-app-list to /app including subdirectories (use WinScp to copy files)
    2. install ASP.NET Core Runtime
    3. configure service for app
    4. configure Nginx

*You can use following installation scripts for Windows [install.ps1](/src/az-vmweb/install.ps1) and Linux Ubuntu [install.sh](/src/az-vmweb/install.sh).*

Check website is running http://<your_win_or_lx>  from your workstation. It's getting error because missing database.

![Web homepage](/src/az-vmweb/web-running.png)

**Enable monitoring**

- create new Azure Log Analytics workspace
- open Virtual Machine resource and enable Insights under Monitoring section

### Deploy database as Azure platform services

Create new Azure Database for MySQL and connect app

- name comysql in resource group rg-co-sql
- enable firewall - Allow access to Azure services
- deploy database [create script](/src/az-sql/init.sql) using MySql Workbench - create database and table
- change connection string on web server - change appsettings.json MovieContext to your ADO.Net connection string

Check website is running http://<your_win_or_lx> from your workstation. You can create new record.

![Web homepage](/src/az-sql/sql-running.png)

*Hint: Enable Development mode for troubleshootings - set [Environment variable](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/aspnet-core-module?#set-environment-variables)*

**Advanced scenarios**

- allow private communication with database - Private Endpoint to get private Ip in snet-comain-db subnet

### Publish web

There are different options how to [publish web to internet](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-lb-with-azure-app-delivery-suite)

- Azure LoadBalancer - L4 load balancer
- Azure Application Gateway - L7 HTTP/HTTPS loadbalancer
- Azure FrontDoor - global HTTP/HTTPS loadbalancer

Configure one of the solution and check website is running http://<your_lb_> from internet.

*Hint: Remember to update NSG rule to allow HTTP traffic from Internet*

**Advanced scenarios**

- create DNS zone - use Azure DNS to get public zone

### Modernize application to Azure platform services

Create new Azure Web App and configure application deployment

- name cowebapp in resource group rg-co-webapp with Code .Net Core 3.1 LTS on Windows
- open FTPS connection - open Deployment Center and select FTP
- copy application from bin/movie-app-list to FTP folder /site/wwwroot
- change connection string on webapp - change appsettings.json MovieContext to your ADO.Net connection string

Check website is running https://cowebapp.azurewebsites.net/ from internet.

### Review monitoring and security settings

Explore Azure Monitor

- review Insight section on virtual machine
- explore metrics, pin chart to dashboard
- create new query in Logs, check [Kusto language reference](https://docs.microsoft.com/en-us/azure/azure-monitor/log-query/query-language)
- create new Alert for metric or query
- create new Azure Monitor Workbook

Query sample

```kusto
Perf 
| where InstanceName == "omsagent"
| where CounterName == "Used Memory kBytes"
| summarize cpuLoad=avg(CounterValue) by Computer, TimeGenerated
| render timechart 
```

You can check this [Azure Academy training lab](https://github.com/azurecz/azuretechacademy-hybridit-labs-day1#vm-monitoring).

Open Azure Security Center

- review recommendation
- customize Default policy

**Advanced scenarios**

- configure autoscaling
- explore Application Insights monitoring
- deploy application to Azure Kubernetes Service AKS

### Automate operations - run scheduled event

Create new Azure Function App

- name coautomat in resource group rg-co-func with PowerShell on Windows (because of Portal development)
- create new function ReportVMStatus with Timer trigger and check Code+Test blade
- enable managed Identity for Azure Function and setup permissions (e.g. Reader on subscription)
- add following source code

```powershell
# Input bindings are passed in via param block.
param($Timer)

try  {
    # Get the current universal time in the default string format.
    $currentUTCtime = (Get-Date).ToUniversalTime()

    # The 'IsPastDue' property is 'true' when the current function invocation is later than scheduled.
    if ($Timer.IsPastDue) {
        Write-Host "PowerShell timer is running late!"
    }

    # Check Azure connectivity
    $AzSubscriptionContext = Get-AzContext -ErrorAction SilentlyContinue
    if ($null -eq $AzSubscriptionContext) {
        throw "This Azure Function need a managed system identity"
    }
    else {
        Write-Host ("Connected to Azure !")
    }

    # list VMs
    $VMs = Get-AzVM
    foreach ($VirtualMachine in $VMs)
    {
        # call to get VM status
        $VM = Get-AzVM -ResourceGroupName $VirtualMachine.ResourceGroupName -Name $VirtualMachine.Name -Status
        Write-Host ("VM status name: $($VM.Name) has status: $($VM.Statuses[1].Code)")
    }
}
catch
{
    throw $_.Exception.Message
}
```

Click Test/Run button and check results
![Function log](/src/az-func/func-automat.png)

### Extend application - trigger event

Create new Azure Function App

- name cofunc in resource group rg-co-func with .Net Core 3.1 on Windows (because of Portal development)
- create new function ProcessTrigger with Event Grid trigger and check Code+Test blade

Configure Trigger subscription fired when VM is started

- select resource group containing VM and select Events
- configure Event subscription with Endpoint Type = Azure Function and select our Function ProcessTrigger

Now let's check Function processing logs

- open Azure Function ProcessTrigger and navigate to Monitor section
- now start VM (other browser window)
- check Logs and wait for event "action": "Microsoft.Compute/virtualMachines/start/action"

![Function log](/src/az-func/func-event.png)

**Advanced scenarios**

- process file uploaded to Azure Blob Storage (e.g. save to another destination)

### Extend application - add workflow

Create Azure LogicApps

- select resource group containing VM and select Events
- select LogicApps and create new workflow - check trigger is Azure Event Grid and Authenticate
- prepare workflow - e.g. create calendar event
