# Session 18 - Terraform and AWS Services
Student: Aditya Prasad  
Roll Number: 24BCS10179

## Status: partial, no AWS resources provisioned
Implemented [terraform-s3-demo](terraform-s3-demo/) and official-source AWS research. Codespaces ran Terraform1.16.5 init, fmt, validate and a mock AWS provider plan test: one passed, zero failed, three proposed resources. See [actual verification output](evidence/s18-output.txt). Live AWS lifecycle is blocked on chosen account/region and cost approval. Mock validation is not a live deployment.

## AWS service research
- [IAM](aws-services/01-iam/README.md)
- [EC2](aws-services/02-ec2/README.md)
- [S3](aws-services/03-s3/README.md)
- [VPC](aws-services/04-vpc/README.md)
- [DynamoDB and RDS](aws-services/05-dynamodb-rds/README.md)

Sources are linked in each README. No credentials, state or paid resources are included.
