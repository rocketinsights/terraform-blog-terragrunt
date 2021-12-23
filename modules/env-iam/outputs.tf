output "ec2_role_id" {
  value = aws_iam_role.ec2_role.id
}

output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}
