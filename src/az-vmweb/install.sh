# Documentation
# https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx

# Install ASP.NET Core Runtime
wget https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh
chmod +x dotnet-install.sh
sudo ./dotnet-install.sh --channel 2.2 --install-dir /cli

# !!! make sure /app is prepared with application !!!
# Service dotNet app
sudo rm /etc/systemd/system/kestrel-myapp.service
cat << EOF | sudo tee -a /etc/systemd/system/kestrel-myapp.service
[Unit]
Description=Example .NET Web API App running on Ubuntu
[Service]
WorkingDirectory=/app
ExecStart=/cli/dotnet /app/MvcMovie.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-example
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable kestrel-myapp.service
sudo systemctl start kestrel-myapp.service
# sudo systemctl status kestrel-myapp.service
# sudo journalctl -u kestrel-myapp.service

# Install Nginx and configure
sudo apt install nginx
sudo rm /etc/nginx/sites-available/default
sudo bash -c 'cat << EOF > /etc/nginx/sites-available/default
server {
    listen        80;
    location / {
        proxy_pass         http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF'
sudo service nginx start
# sudo systemctl status nginx.service
