variable "environment_name" {
  type        = string
  description = "Name of environment"
}

variable "app_id" {
  type        = string
  description = "Name of application"
}

variable "server_count" {
  type        = number
  description = "Number of EC2 instances for this application"
}

variable "server_type" {
  type        = string
  description = "AWS EC2 instance type for this application"
}