variable "environment_name" {
  type        = string
  description = "Name of environment"
}

variable "aws_region" {
  type        = string
  description = "The AWS region of the deployment"
}

variable "server_count" {
  type        = number
  description = "Number of EC2 instances for this application"
}

variable "server_type" {
  type = string
  description = "AWS EC2 instance type for this application"
}