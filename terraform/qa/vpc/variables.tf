variable "environment_name" {
  type        = string
  description = "Name of environment"
}

variable "aws_region" {
  type        = string
  description = "The AWS region of the deployment"
}


variable "aws_azs" {
  type        = list(string)
  description = "The Availabity Zones of the deployment"
}

variable "aws_cidr" {
  type        = string
  description = "The IPv4 CIDR of the VPC"
}

variable "aws_subnets" {
  type        = list(string)
  description = "The IPv4 subnets for aws_cidr"
}

