resource "aws_vpc" "demo" {
  cidr_block = "10.19.0.0/16"
  tags       = { Name = "aditya-s19", Student = "24BCS10179" }
}
resource "aws_subnet" "demo" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.19.1.0/24"
  map_public_ip_on_launch = false
}
resource "aws_security_group" "demo" {
  name_prefix = "aditya-s19-"
  vpc_id      = aws_vpc.demo.id
  description = "Isolated classroom instance: no ingress or egress"
}
resource "aws_instance" "demo" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.demo.id
  vpc_security_group_ids      = [aws_security_group.demo.id]
  associate_public_ip_address = false
  metadata_options { http_tokens = "required" }
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = { Name = "aditya-s19", Student = "24BCS10179" }
}
resource "aws_s3_bucket" "demo" {
  bucket        = var.bucket_name
  force_destroy = false
}
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket                  = aws_s3_bucket.demo.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
