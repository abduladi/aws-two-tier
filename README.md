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

7. Enforced TLS connection for DB data in transit by configuring parameter groups for the cluster and setting the rds.force_ssl flag to 1.






9. Ensured data stores (DB and s3 are private and not publicly accessible)
DB subnet and NACL do not allow traffic from internet gateway. And s3 has is 

10. ensured high availability by distributing each network subnet tier of the architecture into multiple availablity zones

11. implemented routing to enforce zero path the external entities outside the vpc by ensureing no route to the internet gateway is attached to the subnet


12. Implemented logging and monitoring for s3 server access logging, s3 cloudtrail data events and PostgreSQL Database logs. Alarms were created and notification setup for 3 security related events
inspect cloud watch logs for log groups serving as destination for logs from EC2 web service access, s3 cloudtrail events and postgresql. Inspect s3 bucket properties for enabled logging. Inspect cloudwatch log group named "/var/log/messages" for EC2 web service access logs

13. 




8. Used KMS with autmated key rotatioin to manage database password.