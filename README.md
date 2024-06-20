# aws-two-tier

To Deploy the architecture create an aws cli profile called terraform and provide access key ID and secret access key of a user with access keys for CLI created in IAM.
aws configure --profile terraform


Security Capabilities

installed ssl in certificate maanager and attached to application load balancer's listener.

enforced redirect of HTTP traffic to HTTPS

Implemeted web application firewall on the application load balancer

configured autoscaling policy to automate resiliency

implemented secruity groups to control traffic for each subnet. This ensures only required traffic needed for smooth running of the architecture are permitted.

ensured high availability by distributing each network subnet tier of the architecture into multiple availablity zones

implemented routing to enforce zero path the external entities outside the vpc by ensureing no route to the internet gateway is attached to the subnet

