output "web-tg-arn" {
  description = "The ARN of the web target group"
  value       = [aws_lb_target_group.web-tg.arn]
  sensitive   = true
}

output "app-tg-arn" {
  description = "The ARN of the app target group"
  value       = [aws_lb_target_group.app-tg.arn]
  sensitive   = true
}

output "web-alb-dns-name" {
  description = "The DNS name of the web ALB"
  value       = aws_lb.web-alb.dns_name
}

output "web-alb-zone-id" {
  description = "The zone ID of the web ALB"
  value       = aws_lb.web-alb.zone_id
  sensitive   = true
}

output "app-alb-dns-name" {
  description = "The DNS name of the app ALB"
  value       = aws_lb.app-alb.dns_name
}

output "app-alb-zone-id" {
  description = "The zone ID of the app ALB"
  value       = aws_lb.app-alb.zone_id
  sensitive   = true
}
