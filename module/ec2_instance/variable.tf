
variable "pem-key" {
  default = "doc"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "instance-ami" {
  default = "ami-0f8ca728008ff5af4"
  type    = string
}

variable "pub-subnet-id-1" {
  type        = string
  description = "subnet for ec2 instance"
}

variable "pub-subnet-id-2" {
  type        = string
  description = "subnet for ec2 instance"
}
variable "pr-subnet-id-1" {
  type        = string
  description = "subnet for ec2 instance"
}
variable "pr-subnet-id-2" {
  type        = string
  description = "subnet for ec2 instance"
}

variable "vpc-id" {
  type        = string
  description = "vpc for ec2 instance"
}