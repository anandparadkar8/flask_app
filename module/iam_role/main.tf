provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-running-state-1156"
    key    = "global/iam/terraform.tfstate"
    region = "ap-south-1"

  }
}

resource "aws_iam_role" "role-for-ECR" {
  name               = "IAM-role-ECR"
  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  POLICY
  tags = {
    Name = "IAM-role-ECR"
  }
}

resource "aws_iam_role_policy_attachment" "EC2_PROFILE_IMAGE_BUILDER" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.role-for-ECR.name
}

resource "aws_iam_role_policy_attachment" "IAM_READ_ONLY" {
  role       = aws_iam_role.role-for-ECR.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"

}
resource "aws_iam_instance_profile" "EC2-attach" {
  name = "attaching-role-to-ec2"
  role = aws_iam_role.role-for-ECR.name
}