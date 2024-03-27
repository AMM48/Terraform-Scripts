output "acm_certificate" {
  description = "ACM certificate"
  value       = aws_acm_certificate.cert
  sensitive   = true
}

output "dns_zone_id" {
  description = "The zone ID for the DNS zone"
  value       = data.aws_route53_zone.my_dns_zone.zone_id
  sensitive   = true
}
