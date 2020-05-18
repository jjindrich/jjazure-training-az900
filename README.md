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
az group create -n rg-covmjump -l westeurope
az vm create -n covmjump -g rg-covmjump --image win2019datacenter --admin-username azureuser
```

### Explore application source code

Web application Movie App List

- dotNet Core web with mySql database
- Source code - [movie-app-list](/src/movie-app-list)
- configuration - [appsettings.json](/src/movie-app-list/appsettings.json)
- compiled binaries - [movie-app-list](/bin/movie-app-list)

### Deploy application to Azure infrastructure services

TODO

- VM WIN IIS
- VM LINUX apache without  public IP
- VM WIN install application
- VM LINUX install application

### Deploy database as Azure platform services

TODO: deploy DB mySql, change connection string

### Extend application deployment

TODO: Load balancer and backend VM

### Modernize application to Azure platform services

TODO: WebApp with application

### Extend application

TODO: Function with EventGrid
