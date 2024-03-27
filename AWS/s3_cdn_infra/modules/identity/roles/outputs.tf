output "codebuild_role_arn" {
  description = "iam role arn"
  value       = aws_iam_role.codebuild_role.arn
  sensitive   = true
}

output "codebuild_role_id" {
  description = "iam role id"
  value       = aws_iam_role.codebuild_role.id
  sensitive   = true
}
