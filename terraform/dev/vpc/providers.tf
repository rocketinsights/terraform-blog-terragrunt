# In a professional setting, a hard-pin of terraform versions ensures all
# team members use the same version, reducing state conflict
terraform {
  required_version = "1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }

  # Terraform does not allow usage of variables in the backend config
  backend "s3" {
    bucket         = "terraform-plain-tfstate-s3-dev"
    region         = "us-west-1"
    key            = "vpc/terraform.tfstate"
    dynamodb_table = "terraform-plain-tfstate-dynamodb-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  # See info about default_tags at
  # https://blog.rocketinsights.com/best-practices-for-terraform-aws-tags/
  default_tags {
    tags = {
      project     = local.project_name
      app-id      = local.app_id
      environment = var.environment_name

      // This regex results in the terraform git
      // repo name and any sub-directories.
      // For this repo, terraform-base-path is
      // terraform-blog-terragrunt/terraform/dev/vpc
      // In Terragrunt, this awkward regex is simplified by the built-in function path_relative_to_include()
      // This tag helps AWS UI users discover what
      // Terraform git repo and directory to modify
      terraform-base-path = replace(path.cwd, "/^.*?(${local.project_name}\\/)/", "$1")
    }
  }
}
