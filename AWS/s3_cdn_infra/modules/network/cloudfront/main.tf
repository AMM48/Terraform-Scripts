resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  aliases             = var.domain_names
  is_ipv6_enabled     = true
  price_class         = "PriceClass_200"
  default_root_object = "index.html"

  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3-Website-${var.s3_bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin_access_control.id
  }

  default_cache_behavior {
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Website-${var.s3_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    acm_certificate_arn            = var.acm_certificate.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
  }
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/"
  }

  depends_on = [var.s3_bucket, var.acm_certificate]
}

// Create OAC to restrict access to the s3 bucket
resource "aws_cloudfront_origin_access_control" "s3_origin_access_control" {
  name                              = "s3-origin-access-control"
  description                       = "OAC to restrict access to the s3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
