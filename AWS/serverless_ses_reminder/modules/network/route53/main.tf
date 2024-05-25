data "aws_acm_certificate" "domain_cert" {
  domain = "*.${var.domain_name}"
}

data "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "api_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.api_dns_name
    zone_id                = var.api_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront_record" {
  count   = 2
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "email.${var.domain_name}"
  type    = count.index == 0 ? "A" : "AAAA"
  alias {
    name                   = var.cloudfront_dns_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}
