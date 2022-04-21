# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "prod"
aws_region       = "us-east-2"
server_count     = 5
server_type      = "t3.micro"