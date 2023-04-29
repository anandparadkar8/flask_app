
variable "subnet_cidrs_public" {
  default = "10.0.0.0/24"
  type    = string
}

variable "subnet_cidrs_public-2" {
  default = "10.0.1.0/24"
  type    = string
}
variable "aws_region" {
  default = "ap-south-1"
  type    = string
}

variable "vpc_name" {
  default = "demo_vpc"
  type    = string
}

variable "cidr_vpc" {
  default = "10.0.0.0/20"
  type    = string
}

variable "subnet_cidrs_private" {
  default = "10.0.2.0/24"
}

variable "subnet_cidrs_private-2" {
  default = "10.0.3.0/24"
}

variable "availability_zone_1" {
  default = "ap-south-1a"
}

variable "availability_zone_2" {
  default = "ap-south-1b"
}
