locals {
  role_id = {
    lambda_execution_role_id = aws_iam_role.lambda_execution_role.id,
    step_function_role_id    = aws_iam_role.step_function_role.id

  }
}
