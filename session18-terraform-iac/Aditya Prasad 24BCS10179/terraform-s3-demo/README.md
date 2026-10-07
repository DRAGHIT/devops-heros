# Terraform S3 demo
Prepared private encrypted S3 bucket with public-access block. Region and bucket name are example inputs, not an approved AWS destination. `force_destroy=false` avoids silently deleting objects.

## Commands
Codespaces verification: init -backend=false; fmt; validate; test with mock AWS provider. Mock test executes a Terraform plan without AWS calls. This is not evidence of a real S3 bucket.

Live workflow, NOT executed: `terraform plan -out=approved.tfplan`, inspect resource changes and cost/account scope, `terraform apply approved.tfplan`, `terraform show`, `terraform output`, then after cleanup approval `terraform destroy`. Use AWS SSO/short-lived credentials, never commit credentials. State can contain sensitive values; do not publish it. Empty bucket before destroy when required.

## Status
Partial. No live AWS plan, apply, show/output of real resources or destroy has been executed. Requires chosen AWS account/region and concrete cost approval. No claim of free AWS resources.
