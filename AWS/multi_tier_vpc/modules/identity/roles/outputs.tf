output "instance_profile_arn" {
  value     = aws_iam_instance_profile.ec2_ssm_access_profile.arn
  sensitive = true
}
