output "project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.portfolio_website.name
  sensitive   = true
}
