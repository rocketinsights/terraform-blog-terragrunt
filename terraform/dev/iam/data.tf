# In general I am not a big fan of the terraform_remote_state data source to get another modules
# output values because it tightly couples two Terraform modules into one dependency.
# Even Hashicorp does not recommend using the remote_state data source
# https://www.terraform.io/language/state/remote-state-data
#
# I usually prefer storing the shared data in Parameter Store or querying AWS itself for the info
# I use it here only as a Terraform example and to contrast it with the Terragrunt output dependency block
data "terraform_remote_state" "lookup_s3_module" {
  backend = "s3"
  # Notice the cut and paste you have to do to duplicate the s3 backend info
  # from s3/provider.tf
  config = {
    bucket = "terraform-plain-tfstate-s3-dev"
    region = "us-west-1"
    key    = "s3/terraform.tfstate"
  }
}