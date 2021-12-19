# These common Terraform environment variables can be consolidated in the root terragrunt.hcl
environment_name = "dev"
aws_region       = "us-west-1"

# Module variables
aws_azs          = ["us-west-1a", "us-west-1b"]
aws_cidr         = "192.168.0.0/16"
aws_subnets      = ["192.168.101.0/24", "192.168.102.0/24"]
