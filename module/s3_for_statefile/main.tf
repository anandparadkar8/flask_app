provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-running-state-1156"
 
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}