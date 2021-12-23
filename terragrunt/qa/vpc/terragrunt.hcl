# Includes the root terragrunt.hcl configurations
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The _envcommon/vpc.hcl configuration contains VPC settings
# that are common across all environments (dev, qa, prod).
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

locals {
  vpc_aws_region = include.envcommon.locals.vpc_aws_region
}

inputs = {
  azs            = ["${local.vpc_aws_region}a", "${local.vpc_aws_region}b",  "${local.vpc_aws_region}c"]
  cidr           =  "172.16.0.0/12"
  public_subnets =  ["172.18.101.0/24", "172.18.102.0/24", "172.18.103.0/24"]
}
