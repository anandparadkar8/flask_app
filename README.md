# task-repo

First we have to manually create s3 bucket for storing iam, prod and staging terraform state files.

Configure aws Access key ID and Secret access key as secret on github so that github runner can perform neccessary actions like pushing new image to ECR and execute terraform code to create and modify aws infrastructure

Terraform code creates 2 diffrent environments prod and staging

Both environment consists of autoscaling group, ec2 instances placed in private subnets and internet facing load balancer.

App can be accessed using load balancer DNS name

Workflow written for pushing docker image to ECR when new code is pushed to repository.
 
Each time new code is pushed to repository code pipeline runs and and AWS code deploy chnages the application in staging as well as in production.

