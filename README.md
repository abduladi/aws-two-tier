# aws-two-tier

create access key for an IAM user with permissions to create resources.
create an aws config profile for this IAM user

ensure you have the latest version of terraform and AWS provider

Create a fork of the repo here
https://github.com/abduladi/aws-two-tier/

You can decide to run terraform locally or use the pipeline setup for easy management.

To run locally, 
1. update the provider.tf and remove the "Integration with HCP" block
2. update the provider block of the provider.tf file to include your aws config profile
3. run terraform plan and terraform apply to deploy the code from the root directory





Security Capabilities Implemented
=================================

installed ssl in certificate maanager and attached to application load balancer's listener.

enforced redirect of HTTP traffic to HTTPS. These two are to support the encryption of data in transit

Implemeted web application firewall on the application load balancer

configured autoscaling policy to automate resiliency

implemented secruity groups to control traffic for each subnet. This ensures only required traffic needed for smooth running of the architecture are permitted.

Implemented data encryption for all data at rest both in database and s3 buckets.

Ensured data stores (DB and s3 are private and not publicly accessible)

ensured high availability by distributing each network subnet tier of the architecture into multiple availablity zones

implemented routing to enforce zero path the external entities outside the vpc by ensureing no route to the internet gateway is attached to the subnet

