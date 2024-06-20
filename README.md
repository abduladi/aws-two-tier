Multi Tier Application on AWS
=================================

create access key for an IAM user with permissions to create resources.
create an aws config profile for this IAM user

ensure you have the latest version of terraform and AWS provider

Create a fork of this repo

You can decide to run terraform locally or use the pipeline setup for better management of states.

To run locally, 
1. update the provider.tf and remove the "Integration with HCP" block
2. update the provider block of the provider.tf file to include your aws config profile
3. run terraform plan and terraform apply to deploy the code from the root directory


To run using the integrated git hub actions,
1. Follow this guide to register and configure a workspace in TerraformIO and register AWS IAM access key and secret access key and also generate a token for github actions integration
2. Where you are required to setup a github repository in the guide, 
   create a fork of this project instead and continue with the instructions to register terraform token as github secret 
   https://developer.hashicorp.com/terraform/tutorials/automation/github-actions
4. update the "TF_CLOUD_ORGANIZATION" and "TF_WORKSPACE" pipeline environment fields in the hcp-plan.yml and hcp-apply.yml files with the organization and workspace names from step 1 respectively.
5. commit your changes and push to remote.
6. Got to github actions to trigger any of the pipelines
7. navigate to terraform io to view the details of pipeline run






Security Capabilities Implemented
=================================

1. installed ssl in certificate maanager and attached to application load balancer's listener.
inspect load balance https listener for certificate attachment. 

2. enforced redirect of HTTP traffic to HTTPS. These two are to support the encryption of data in transit
get the elb dns name from the loab balancer details section in console
call the endpoint to validate redirect to https with slef signed certifcate 

3. Implemeted web application firewall on the application load balancer
from elb detail page, change tab to integrations. Locate WAF integration detect status

4. configured autoscaling policy to automate resiliency
from autoscaling group detail page, change tab to Automatic Scaling to locate two auto scaling policies


5. implemented secruity groups to control traffic for each subnet. This ensures only required traffic needed for smooth running of the architecture are permitted.

from Security groups resource page inspect newly provisioned security groups with inbound and outbound rules defined to enforce only needed traffic permissions

6. Implemented data encryption for all data at rest both in database and s3 buckets.
For data encryption, I have choosen the server side encryption managed by AWS to ensure encrytion of data in transit. This encryption method is symmetric and is managed by AWS key management service and come with additional benefits like automated rotation. There is room to provide 



7. Enforced TLS connection for DB data in transit by configuring parameter groups for the cluster and setting the rds.force_ssl flag to 1.
navigate to parameter groups and choose the custom parameter grouproup named app-db-pg. Filter for the flag of rds.force_ssl and confirm the value is set to 1





9. Ensured data stores (DB and s3 are private and not publicly accessible)
DB subnet and NACL do not allow traffic from internet gateway. And s3 has is 

10. ensured high availability by distributing each network subnet tier of the architecture into multiple availablity zones


11. Implemented logging and monitoring for s3 server access logging, s3 cloudtrail data events and PostgreSQL Database logs. Alarms were created and notification setup for 3 security related events
inspect cloud watch logs for log groups serving as destination for logs from EC2 web service access, s3 cloudtrail events and postgresql. Inspect s3 bucket properties for enabled logging. Inspect cloudwatch log group named "/var/log/messages" for EC2 web service access logs


8. Used KMS with autmated key rotatioin to manage database password.




Second part
===========

To update a fleet of instances with a new configuration or installation of an agent, I will leverage enterprise ready configuration management tools like Ansible. This gives alot of flexibility to manage configuration requirements and patches for already provisioned resources. Among its benefits is that it is agentless and doesn't consume heavy network resources since it works with a push mechanism. It does not need to maintain connection with resources to pull configurations. It also uses a very simple to read declarative yaml syntax which alot of engineers are typically familiar with. When running these scripts, sensitive parameters need to be passed to these systems to facilitate these new configurations or installations. It is best practice to save these parameters as secrets in a secure secrets management service like AWS Secrets manager. The secrets are securely fetched and used by scripts, which have variables declarations for these parameters, during execution. This way, engineers do not have to interact with these sensitive parameters othen than once, when they need to be safely stored, there by reducing the possibility of human error significantly, and hehancing security of the parameters. Example of parameters include license keys, integration keys, login credentials (username and password or access tokens), etc. It is also worthy to note that these secrets are kept safe by the implementation of a combination key encryption keys and data encryption keys to ensure confidentiality.
