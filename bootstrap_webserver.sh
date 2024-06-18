#!/bin/bash

# Update package lists
sudo apt update

# Install Apache
sudo apt install -y apache2

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2

# Create a simple HTML file in the default web root
echo "Hello World" | sudo tee /var/www/html/index.html