resource "aws_cloudwatch_log_group" "log_group" {
  name            = "sfn-log-group"
  log_group_class = "STANDARD"
}
