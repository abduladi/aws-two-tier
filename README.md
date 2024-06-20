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

2. enforced redirect of HTTP traffic to HTTPS. These two are to support the encryption of data in transit

3. Implemeted web application firewall on the application load balancer

4. configured autoscaling policy to automate resiliency

5. implemented secruity groups to control traffic for each subnet. This ensures only required traffic needed for smooth running of the architecture are permitted.

6. Implemented data encryption for all data at rest both in database and s3 buckets.

7. Ensured data stores (DB and s3 are private and not publicly accessible)

8. ensured high availability by distributing each network subnet tier of the architecture into multiple availablity zones

9. implemented routing to enforce zero path the external entities outside the vpc by ensureing no route to the internet gateway is attached to the subnet

