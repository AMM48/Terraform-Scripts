output "vpc-id" {
  description = "The VPC ID"
  value       = aws_vpc.myVPC.id
  sensitive   = true
}

output "subnets" {
  description = "The subnets"
  value       = aws_subnet.mySubnets
}

output "web-sg" {
  description = "The security group to use for the web ASG"
  value       = [aws_security_group.web-sg.id]
}

output "app-sg" {
  description = "The security group to use for the app ASG"
  value       = [aws_security_group.app-sg.id]
}

output "db-sg" {
  description = "The security group to use for the db ASG"
  value       = [aws_security_group.db-sg.id]
}

output "web-alb-sg" {
  description = "The security group to use for the web ALB"
  value       = [aws_security_group.web-alb-sg.id]
}

output "app-alb-sg" {
  description = "The security group to use for the app ALB"
  value       = [aws_security_group.app-alb-sg.id]
}
