#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "<center><h1>Welcome to Server: $(hostname -i)</h1><br><br></center>" > /var/www/html/index.html

# EC2 webservice access logs configurations
# this installs, starts, and enables cloudwatch logs agent service
sudo yum install -y awslogs
sudo systemctl start awslogsd
sudo systemctl enable awslogsd


# creat conf file for cloudwatch logs agent
cat <<EOT > /etc/awslogs/config/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = {instance_id}

[/var/log/webapp/access.log]
file = /var/log/webapp/access.log
log_group_name = /var/log/webapp/access.log
log_stream_name = {instance_id}
EOT

# restart cloud watch logs agent service for configuration file above to take effect
sudo systemctl restart awslogsd
