variable "aws_region" {
  default = "ap-south-1"
  type    = string
}

variable "cidr_vpc" {
  default = "10.0.0.0/21"
  type    = string
}

variable "vpc_name" {
  default = "staging_vpc"
  type    = string
}

variable "subnet_cidrs_public_1" {
  default = "10.0.0.0/27"
  type    = string
}

variable "subnet_cidrs_public_2" {
  default = "10.0.0.64/27"
  type    = string
}


variable "subnet_cidrs_private_1" {
  default = "10.0.0.32/27"
  type    = string
}

variable "subnet_cidrs_private_2" {
  default = "10.0.1.0/27"
  type    = string
}

variable "availability_zone_1" {
  default = "ap-south-1a"
}

variable "availability_zone_2" {
  default = "ap-south-1b"
}

variable "pem-key" {
  default = "doc"
  type    = string
}

variable "instance_type" {
  default = "t2.medium"
  type    = string
}

variable "instance-ami" {
  default = "ami-0f8ca728008ff5af4"
  type    = string
}