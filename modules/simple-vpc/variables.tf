variable "environment_name" {
  type        = string
  description = "Name of environment"
}

variable "app_id" {
  type        = string
  description = "Name of application"
}

variable "azs" {
  type        = list(string)
  description = "The Availability Zones of the deployment"
}

variable "cidr" {
  type        = string
  description = "The IPv4 CIDR of the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "The IPv4 public subnets for aws_cidr"
}

