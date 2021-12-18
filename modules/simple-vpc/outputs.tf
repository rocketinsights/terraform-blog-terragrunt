output "azs" {
  value = module.terraform_simple_vpc.azs
}

output "igw_id" {
  value = module.terraform_simple_vpc.igw_id
}

output "igw_arn" {
  value = module.terraform_simple_vpc.igw_arn
}

output "public_internet_gateway_route_id" {
  value = module.terraform_simple_vpc.public_internet_gateway_route_id
}

output "public_subnets" {
  value = module.terraform_simple_vpc.public_subnets
}

output "public_subnet_arns" {
  value = module.terraform_simple_vpc.public_subnet_arns
}

output "vpc_id" {
  value = module.terraform_simple_vpc.vpc_id
}
