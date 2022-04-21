# In Terraform, you have to declare duplicate environment_name and aws_region in all
# the resources variables.tf
# In Terragrunt, these environment common variables are defined in one env.hcl
# Terragrunt automatically uses the variables without having to explicitly declare them
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