variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "cidr_vpc" {
  default = "10.97.236.0/23"
  type    = string
}

variable "vpc_name" {
  default = "prod_vpc"
  type    = string
}

variable "subnet_cidrs_public_1" {
  default = "10.97.236.0/27"
  type    = string
}

variable "subnet_cidrs_public_2" {
  default = "10.97.236.32/27"
  type    = string
}


variable "subnet_cidrs_private_1" {
  default = "10.97.236.64/27"
  type    = string
}

variable "subnet_cidrs_private_2" {
  default = "10.97.236.96/27"
  type    = string
}

variable "availability_zone_1" {
  default = "us-east-1a"
}

variable "availability_zone_2" {
  default = "us-east-1b"
}


variable "pem-key" {
  default = "project"
  type    = string
}

variable "instance_type" {
  default = "t2.medium"
  type    = string
}

variable "instance-ami" {
  default = "ami-007855ac798b5175e"
  type    = string
}
