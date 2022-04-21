# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "qa"
aws_region       = "us-east-1"
server_count     = 3
server_type      = "t2.micro"