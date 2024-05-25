output "bucket_regional_domain_name" {
  description = "s3 bucket regional domain name"
  value       = aws_s3_bucket.petcuddleotron.bucket_regional_domain_name
  sensitive   = true
}

output "s3_bucket" {
  description = "s3 bucket"
  value       = aws_s3_bucket.petcuddleotron
  sensitive   = true
}
