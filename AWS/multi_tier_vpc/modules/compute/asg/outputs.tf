output "web-asg-name" {
  description = "The name of the web ASG"
  value       = aws_autoscaling_group.web-asg.name
}

output "web-scale-policy-out-arn" {
  description = "The ARN of the web scaling out policy"
  value       = aws_autoscaling_policy.web_scale_policy_out.arn
  sensitive   = true
}

output "web-scale-policy-in-arn" {
  description = "The ARN of the web scaling in policy"
  value       = aws_autoscaling_policy.web_scale_policy_in.arn
  sensitive   = true
}

output "app-asg-name" {
  description = "The name of the app ASG"
  value       = aws_autoscaling_group.app-asg.name
}

output "app-scale-policy-out-arn" {
  description = "The ARN of the app scaling out policy"
  value       = aws_autoscaling_policy.app_scale_policy_out.arn
  sensitive   = true
}

output "app-scale-policy-in-arn" {
  description = "The ARN of the app scaling in policy"
  value       = aws_autoscaling_policy.app_scale_policy_in.arn
  sensitive   = true
}
