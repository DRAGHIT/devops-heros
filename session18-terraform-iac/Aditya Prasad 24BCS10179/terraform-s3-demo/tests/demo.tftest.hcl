mock_provider "aws" {}
run "private_bucket_plan" {
  command = plan
  assert {
    condition = aws_s3_bucket.demo.bucket == var.bucket_name
    error_message = "Bucket naming mismatch"
  }
  assert {
    condition = aws_s3_bucket_public_access_block.demo.block_public_policy
    error_message = "Public bucket policy must be blocked"
  }
}
