locals {
  environment_name = "dev"
  aws_region       = "us-west-1"
  azs              = ["${local.aws_region}a", "${local.aws_region}b"]
  cidr             =  "192.168.0.0/16"
  public_subnets   =  ["192.168.101.0/24", "192.168.102.0/24"]
  bucket_name      = "simple-s3"
}