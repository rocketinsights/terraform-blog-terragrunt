# These Terraform environment variables are duplicated each resource terraform.tfvars
# In Terragrunt, these variables are consolidated in one env.hcl
environment_name = "dev"
aws_region       = "us-west-1"
bucket_name      = "simple_s3"