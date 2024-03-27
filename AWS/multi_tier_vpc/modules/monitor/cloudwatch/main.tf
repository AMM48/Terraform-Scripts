resource "aws_cloudwatch_metric_alarm" "web_scale_out" {
  alarm_description   = "Monitors CPU utilization for web ASG"
  alarm_actions       = [var.web_scale_policy_out_arn]
  alarm_name          = "web_scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "60"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "web_scale_in" {
  alarm_description   = "Monitors CPU utilization for web ASG"
  alarm_actions       = [var.web_scale_policy_in_arn]
  alarm_name          = "web_scale_in"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "40"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.web_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "app_scale_out" {
  alarm_description   = "Monitors CPU utilization for app ASG"
  alarm_actions       = [var.app_scale_policy_out_arn]
  alarm_name          = "app_scale_out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "60"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "app_scale_in" {
  alarm_description   = "Monitors CPU utilization for app ASG"
  alarm_actions       = [var.app_scale_policy_in_arn]
  alarm_name          = "app_scale_in"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "40"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = var.app_asg_name
  }
}
