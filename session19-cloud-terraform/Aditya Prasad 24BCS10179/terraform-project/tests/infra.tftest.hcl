mock_provider "aws" {}
run "isolated_architecture" {
  command = plan
  assert {
    condition = !aws_instance.demo.associate_public_ip_address
    error_message = "Must not allocate public IP"
  }
  assert {
    condition = aws_instance.demo.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 required"
  }
}
