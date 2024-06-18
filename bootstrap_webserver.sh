#!/bin/bash

yum update -y

sudo amazon-linux-extras install epel -y

sudo yum install stress -y

amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

yum install -y httpd

systemctl start httpd

systemctl enable httpd

usermod -a -G apache ec2-user

chown -R ec2-user:apache /var/www

chmod 2775 /var/www

find /var/www -type d -exec chmod 2775 {} \;

find /var/www -type f -exec chmod 0664 {} \;

echo '<center><h1>Welcome to Server: <?php echo $_SERVER["SERVER_ADDR"]; ?></h1><br><br></center>' > /var/www/html/index.php