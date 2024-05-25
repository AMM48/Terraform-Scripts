output "lambda_arn" {
  value     = aws_lambda_function.ses_lambda.arn
  sensitive = true
}
