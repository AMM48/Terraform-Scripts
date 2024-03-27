// reference the hosted zone
data "aws_route53_zone" "my_dns_zone" {
  name         = var.domain_name[1]
  private_zone = false
}

// create the DNS records for web ALB
resource "aws_route53_record" "web-alb-dns" {
  count   = 2
  zone_id = var.dns-zone-id
  name    = "test.${var.domain_name[1]}"
  type    = count.index == 0 ? "A" : "AAAA"
  alias {
    name                   = var.web-alb-dns-name
    zone_id                = var.web-alb-zone-id
    evaluate_target_health = false
  }
}

// create the DNS records for app ALB
resource "aws_route53_record" "app-alb-dns" {
  count   = 2
  zone_id = var.dns-zone-id
  name    = "api.${var.domain_name[1]}"
  type    = count.index == 0 ? "A" : "AAAA"
  alias {
    name                   = var.app-alb-dns-name
    zone_id                = var.app-alb-zone-id
    evaluate_target_health = false
  }
}

// reference the ACM certificate for the domain
data "aws_acm_certificate" "domainCert" {
  domain = var.domain_name[0]
}
