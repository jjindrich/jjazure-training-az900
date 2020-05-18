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

## Azure advanced lab

### Deploy Windows jump server

Deploy new Windows Server 2019 as workstation

- use Azure portal - create new server with public IP address
- use following script

```bash
az group create -n rg-co-vmjump -l westeurope
az vm create -n covmjump -g rg-co-vmjump --image win2019datacenter --admin-username azureuser
```

Install Edge browser, Azure CLI and VS Code into your Azure workstation

```powershell
Invoke-WebRequest "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?ProductreleaseID=Edge&platform=Default&version=Edge&source=EdgeStablePage&Channel=Stable&language=en" -OutFile MicrosoftEdgeSetup.exe
.\MicrosoftEdgeSetup.exe /install
Invoke-WebRequest "https://aka.ms/installazurecliwindows" -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
Invoke-WebRequest "https://go.microsoft.com/fwlink/?Linkid=852157" -OutFile VSCodeSetup-x64.exe
.\VSCodeSetup-x64.exe /silent
```

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

or use script

```bash
cd src/az-networking
az group create -n rg-co-network -l westeurope
az deployment group create -n Network -g rg-co-network --template-file deploy.json --parameters deploy.params.json
```

**Deploy web application** with Azure Portal

- create new Windows 2019 virtual machine cowmwebwin in resource group rg-vmwebwin *without publicIP and no public ports* network vnet-comain
- create new Ubuntu 18.04 virtual machine cowmweblx in resource group rg-vmweblx *without publicIP and no public ports* network vnet-comain
- install application on Windows - https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis
    1. install IIS and ASP.NET Core Runtime Windows Hosting Bundle Installer
    2. configure IIS site
    3. copy application from bin/movie-app-list to IIS site folder
- install application on Linux - https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx
    1. install ASP.NET Core Runtime
    2. copy application from bin/movie-app-list to /app
    3. configure service for app
    4. configure Nginx

Check website is running http://<your_win_or_lx>. It's getting error because missing database.

![Web homepage](/src/az-vmweb/web-running.png)

### Deploy database as Azure platform services

TODO: deploy DB mySql, change connection string

### Extend application deployment

TODO: Load balancer and backend VM

### Modernize application to Azure platform services

TODO: WebApp with application

### Extend application

TODO: Function with EventGrid
