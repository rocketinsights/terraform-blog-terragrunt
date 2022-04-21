# In Terraform, there are multiple near-identical cut and paste providers.tf
# In Terragrunt, all these settings are centralized in one root terragrunt/terragrunt.hcl

# In a professional setting, a hard-pin of terraform versions ensures all
# team members use the same version, reducing state conflict.
# In Terraform, changing these version numbers require changing multiple providers.tf
# In Terragrunt, these version settings are changed in one root terragrunt/terragrunt.hcl
terraform {
  required_version = "1.1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }

  # Terraform does not allow usage of variables in the backend config resulting in a lot of
  # hard-coding and duplicate entries in multiple providers.tf .
  # Each Terraform configuration will need its own hard-coded unique key,
  # which can lead to cut and paste operational errors.
  #
  # In Terragrunt, the backend settings are centralized using the remote_state block in one root terragrunt.hcl
  # and variables can be used.
  # In addition, the Terragrunt path_relative_to_include() function can ensure that the backend key is dynamic.
  backend "s3" {
    bucket         = "terraform-plain-tfstate-s3-dev"
    region         = "us-west-1"
    key            = "app-main/terraform.tfstate"
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
      // terraform-blog-terragrunt/terraform/dev/s3
      // In Terragrunt, this awkward regex is simplified by the built-in function path_relative_to_include()
      // This tag helps AWS UI users discover what
      // Terraform git repo and directory to modify
      terraform-base-path = replace(path.cwd, "/^.*?(${local.project_name}\\/)/", "$1")
    }
  }
}
