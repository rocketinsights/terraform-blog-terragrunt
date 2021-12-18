################################################################################
# VPC Module
################################################################################
module "terraform_simple_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "${var.app_id}-vpc-${var.environment_name}"
  cidr = var.cidr

  azs            = var.azs
  public_subnets = var.public_subnets

  enable_ipv6             = false
  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  create_igw             = true
  create_egress_only_igw = false
  enable_nat_gateway     = false

  igw_tags = {
    Name = "${var.app_id}-igw-${var.environment_name}"
  }
  public_subnet_tags = {
    Name = "${var.app_id}-subnet-public-${var.environment_name}"
  }
  public_route_table_tags = {
    Name = "${var.app_id}-route-table-public-${var.environment_name}"
  }
}
