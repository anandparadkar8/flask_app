provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-running-state-1156"
    key    = "global/staging/terraform.tfstate"
    region = "ap-south-1"

  }
}

module "network" {
  source                 = "../vpc"
  vpc_name               = var.vpc_name
  cidr_vpc               = var.cidr_vpc
  availability_zone_1    = var.availability_zone_1
  availability_zone_2    = var.availability_zone_2
  subnet_cidrs_public    = var.subnet_cidrs_public_1
  subnet_cidrs_public-2  = var.subnet_cidrs_public_2
  subnet_cidrs_private   = var.subnet_cidrs_private_1
  subnet_cidrs_private-2 = var.subnet_cidrs_private_2
}

module "ec2-server" {
  pem-key         = var.pem-key
  instance-ami    = var.instance-ami
  instance_type   = var.instance_type
  source          = "../ec2_instance"
  vpc-id          = module.network.vpc_id
  pub-subnet-id-1 = module.network.pub_subnet_id_1
  pub-subnet-id-2 = module.network.pub_subnet_id_2
  pr-subnet-id-1  = module.network.pr_subnet_id_1
  pr-subnet-id-2  = module.network.pr_subnet_id_2
}