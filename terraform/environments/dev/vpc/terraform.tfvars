# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "dev"
aws_region       = "us-west-1"

# Module variables
# Note that terraform.tfvars are constants and cannot interpolate other variables like "${var.aws_region}a"
aws_azs          = ["us-west-1a", "us-west-1b"]
aws_cidr         = "192.168.0.0/16"
aws_subnets      = ["192.168.101.0/24", "192.168.102.0/24"]
