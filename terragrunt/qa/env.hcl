# Configuration variables for the qa environment
# Replaces duplicate Terraform environment terraform.tfvars in all Terraform infrastructure code
# Seeing all the qa environment variables in one place make it easier to
# understand and configure the whole environment
locals {
  environment_name = "qa"
  aws_region       = "us-east-1"
  # Note that terraform.tfvars cannot interpolate variables so the azs would have
  # hard-coded values, like us-west-1a and us-west-1b
  azs              = ["${local.aws_region}a", "${local.aws_region}b", "us-east-1c"]
  cidr             =  "172.16.0.0/12"
  public_subnets   =  ["172.18.101.0/24", "172.18.102.0/24", "172.18.103.0/24"]
  bucket_name      = "simple-s3"
  server_count     = 3
  server_type      = "t2.micro"
}
