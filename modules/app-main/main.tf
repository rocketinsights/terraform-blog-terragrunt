resource "aws_instance" "default-tags-ec2" {
  count                = var.server_count
  instance_type        = var.server_type
  ami                  = data.aws_ami.ec2_ami.id
  iam_instance_profile = data.aws_iam_role.ec2_role.arn

  # Ensures equal distribution of EC2 in the subnets.
  # element automatically does a modulo if count.index is greater than length of subnet IDs
  subnet_id = element(data.aws_subnet_ids.ec2_subnets.ids, count.index)

  tags = {
    Name = "${var.app_id}-vpc-${var.environment_name}-${count.index}"
  }

  # Assigns the default tags to volumes attached to this EC2 instance
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#volume_tags
  volume_tags = data.aws_default_tags.provider.tags
}