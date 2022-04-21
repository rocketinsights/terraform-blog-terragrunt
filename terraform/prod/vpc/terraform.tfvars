# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "prod"
aws_region       = "us-east-2"

# Module variables
# Note that terraform.tfvars are constants and cannot interpolate other variables like "${var.aws_region}a"
aws_azs       = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
aws_cidr      =  "10.0.0.0/8"
aws_subnets   =  ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
