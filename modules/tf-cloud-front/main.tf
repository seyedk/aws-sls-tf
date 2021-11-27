provider "aws" {
  alias = "deployment"
}

provider "aws" {
  alias = "cfCert"
}

locals {
  cdn_user_agent = "cloudfront,${var.dns_zone_name}"
}

resource "aws_cloudfront_distribution" "default_site_distribution" {
  provider = aws.deployment
  origin {
    domain_name = aws_s3_bucket.website.website_endpoint
    origin_id   = "${var.dns_zone_name}_bucket"

    custom_header {
      name  = "User-Agent"
      value = local.cdn_user_agent
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.dns_zone_name} CF Distribution"
  default_root_object = "index.html"

  aliases = [var.dns_zone_name]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.dns_zone_name}_bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = var.lambda_edge_trigger
      lambda_arn   = var.lambda_edge_arn
      include_body = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = var.tags
  viewer_certificate {
    # Implicit Dependency on certificate arn 
    acm_certificate_arn = var.use_imported_cert ? data.aws_acm_certificate.issued[0] : try(aws_acm_certificate_validation.cert[0].certificate_arn,"")
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

}

data "aws_acm_certificate" "issued" {
  count    = var.use_imported_cert ? 1 : 0
  
  provider = aws.cfCert
  domain   = var.dns_zone_name
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "selected" {
  provider     = aws.deployment
  name         = var.dns_zone_name
  private_zone = false
}

resource "aws_route53_record" "primary" {
  provider = aws.deployment
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.dns_zone_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.default_site_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.default_site_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  count = var.use_imported_cert ? 0 : 1

  provider = aws.cfCert
  domain_name = var.dns_zone_name

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.cfCert
  for_each = var.use_imported_cert ? {} : {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  count = var.use_imported_cert ? 0 : 1

  provider = aws.cfCert
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
