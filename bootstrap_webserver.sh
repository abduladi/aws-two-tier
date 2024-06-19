#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "<center><h1>Welcome to Server: $(hostname -i)</h1><br><br></center>" > /var/www/html/index.html