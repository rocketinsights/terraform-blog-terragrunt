# Configuration variables for the dev environment
# Replaces duplicate Terraform environment terraform.tfvars in all Terraform infrastructure code
# Seeing all the dev environment variables in one place make it easier to
# understand and configure the whole environment
locals {
  environment_name = "dev"
  aws_region       = "us-west-1"
  # Note that terraform.tfvars cannot interpolate variables so the azs would have
  # hard-coded values, like us-west-1a and us-west-1b
  azs              = ["${local.aws_region}a", "${local.aws_region}b"]
  cidr             =  "192.168.0.0/16"
  public_subnets   =  ["192.168.101.0/24", "192.168.102.0/24"]
  bucket_name      = "simple-s3"
  server_count     = 1
  server_type      = "t2.nano"
}