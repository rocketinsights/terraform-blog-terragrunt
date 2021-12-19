# Includes the root terragrunt.hcl configurations
include "root" {
  path = find_in_parent_folders()
}

terraform {
  # No need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../../..//modules/simple-vpc
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/simple-vpc?ref=main"
}

inputs = {
  azs            = ["us-west-1a", "us-west-1b"],
  cidr           =  "192.168.0.0/16",
  public_subnets =  ["192.168.101.0/24", "192.168.102.0/24"]
}