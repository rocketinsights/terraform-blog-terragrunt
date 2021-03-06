# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "qa"
aws_region       = "us-east-1"

# Module variables
# Note that terraform.tfvars are constants and cannot interpolate other variables like "${var.aws_region}a"
aws_azs          = ["us-east-1a", "us-east-1b", "us-east1c"]
aws_cidr         = "172.16.0.0/12"
aws_subnets      = ["172.18.101.0/24", "172.18.102.0/24", "172.18.103.0/24"]
