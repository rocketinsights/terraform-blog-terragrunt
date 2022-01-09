# In Terraform, you have to declare duplicate environment_name and aws_region in all
# the resources variables.tf
# In Terragrunt, these environment common variables are defined in one env.hcl
# Terragrunt automatically used the variables without having to explicitly declare them
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
  description = "The Availability Zones of the deployment"
}

variable "aws_cidr" {
  type        = string
  description = "The IPv4 CIDR of the VPC"
}

variable "aws_subnets" {
  type        = list(string)
  description = "The IPv4 subnets for aws_cidr"
}

