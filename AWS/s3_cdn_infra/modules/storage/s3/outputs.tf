output "bucket_regional_domain_name" {
  description = "s3 bucket regional domain name"
  value       = aws_s3_bucket.portfolio_website.bucket_regional_domain_name
  sensitive   = true
}

output "s3_bucket_id" {
  description = "s3 bucket id"
  value       = aws_s3_bucket.portfolio_website.id
  sensitive   = true
}

output "s3_bucket_arn" {
  description = "s3 bucket arn"
  value       = aws_s3_bucket.portfolio_website.arn
  sensitive   = true
}

output "s3_bucket" {
  description = "s3 bucket"
  value       = aws_s3_bucket.portfolio_website
  sensitive   = true
}
