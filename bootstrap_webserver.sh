# #!/bin/bash

yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<center><h1>Welcome to Server: $(hostname -i)</h1><br><br></center>" > /var/www/html/index.html
