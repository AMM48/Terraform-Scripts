output "lambda_execution_role_arn" {
  value     = aws_iam_role.lambda_execution_role.arn
  sensitive = true
}

output "step_functions_role_arn" {
  value     = aws_iam_role.step_function_role.arn
  sensitive = true
}

output "api_role_arn" {
  value     = aws_iam_role.api_gateway_role.arn
  sensitive = true
}
