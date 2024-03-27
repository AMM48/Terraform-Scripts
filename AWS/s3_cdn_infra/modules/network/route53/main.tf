// create the TLS certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = "*.${var.domain_names[1]}"
  validation_method         = "DNS"
  subject_alternative_names = [var.domain_names[1]]
  key_algorithm             = "RSA_2048"

  lifecycle {
    create_before_destroy = true
  }
}

// validate the TLS certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_records : record.fqdn]
}

// read the DNS Zone
data "aws_route53_zone" "my_dns_zone" {
  name         = var.domain_names[1]
  private_zone = false
}

// create the DNS records for ACM validation
resource "aws_route53_record" "dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      ttl    = 60
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = var.dns_zone_id
  ttl             = each.value.ttl
}

// create A & AAAA records for cloudfront distribution
resource "aws_route53_record" "cf_records" {
  for_each = {
  for record in var.cf_records_map : "${record.domain}_${record.type}" => record }
  zone_id = var.dns_zone_id
  name    = each.value.domain
  type    = each.value.type
  alias {
    name                   = var.cloudfront_distribution_domain_name
    zone_id                = var.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
