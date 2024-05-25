output "domain_name" {
  description = "cloudfront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  sensitive   = true
}

output "hosted_zone_id" {
  description = "cloudfront distribution hosted zone id"
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  sensitive   = true
}

output "arn" {
  description = "cloudfront distribution arn"
  value       = aws_cloudfront_distribution.s3_distribution.arn
  sensitive   = true
}
