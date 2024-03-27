output "acm-cert-arn" {
  description = "The ARN of the ACM certificate"
  value       = data.aws_acm_certificate.domainCert.arn
  sensitive   = true
}

output "dns-zone-id" {
  description = "The zone ID for the DNS zone"
  value       = data.aws_route53_zone.my_dns_zone.zone_id
  sensitive   = true
}
