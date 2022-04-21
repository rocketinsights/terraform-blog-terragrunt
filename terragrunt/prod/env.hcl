# Configuration variables for the prod environment
# Replaces duplicate Terraform environment terraform.tfvars in all Terraform infrastructure code
# Seeing all the prod environment variables in one place make it easier to
# understand and configure the whole environment
locals {
  environment_name = "prod"
  aws_region       = "us-east-2"
  # Note that terraform.tfvars cannot interpolate variables so the azs would have
  # hard-coded values, like us-west-1a and us-west-1b
  azs              = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  cidr             =  "10.0.0.0/8"
  public_subnets   =  ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
  bucket_name      = "simple-s3"
  server_count     = 5
  server_type      = "t3.micro"
}
