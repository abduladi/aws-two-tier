# aws-two-tier

To Deploy the architecture create an aws cli profile called terraform and provide access key ID and secret access key of a user with access keys for CLI created in IAM.
aws configure --profile terraform

From the root folder, Create certificates for https on application load balancer

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

Upload the certificates to IAM

aws iam upload-server-certificate --server-certificate-name my-self-signed-cert --certificate-body file://cert.pem --private-key file://key.pem --profile terraform


View the server certificates to get the arn.
aws iam list-server-certificates --profile terraform

update the server-cert variable's arn in variables file
arn:aws:iam::158352560240:server-certificate/my-self-signed-cert