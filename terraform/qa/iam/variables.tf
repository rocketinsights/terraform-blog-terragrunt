variable "environment_name" {
  type        = string
  description = "Name of environment"
}

variable "aws_region" {
  type        = string
  description = "The AWS region of the deployment"
}

variable "bucket_name" {
  type        = string
  description = "Name of app S3 bucket"
}