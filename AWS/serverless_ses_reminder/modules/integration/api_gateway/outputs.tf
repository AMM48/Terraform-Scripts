output "cloudfront_domain_name" {
  value     = aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name
  sensitive = true
}

output "api_dns_name" {
  value     = aws_api_gateway_domain_name.custom_domain.regional_domain_name
  sensitive = true
}

output "api_gateway_regional_id_zone" {
  value     = aws_api_gateway_domain_name.custom_domain.regional_zone_id
  sensitive = true
}
