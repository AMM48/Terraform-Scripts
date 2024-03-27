output "endpoint" {
  description = "The endpoint of the RDS cluster"
  value       = aws_rds_cluster.rds_cluster.endpoint
  sensitive   = true
}

output "reader_endpoint" {
  description = "The reader endpoint of the RDS cluster"
  value       = aws_rds_cluster.rds_cluster.reader_endpoint
  sensitive   = true
}
