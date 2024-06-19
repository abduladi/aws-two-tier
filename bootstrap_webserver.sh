# #!/bin/bash

# yum update -y
# yum install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "<center><h1>Welcome to Server: $(hostname -i)</h1><br><br></center>" > /var/www/html/index.html




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