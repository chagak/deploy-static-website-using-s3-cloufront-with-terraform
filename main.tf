# Terraform AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# import the local values from the console
locals {
  aws_s3_bucket = "chaganote-static-honey-web"
  domain = "www.fodek.homes"
  hosted_zone_id = "Z02690399EZ7LDAAPLJC"
  acm_certificate_arn = "arn:aws:acm:us-east-1:871909687521:certificate/97aa2953-7e03-4822-93d6-7fe7c0fc6501"
}

# Create S3 bucket
resource "aws_s3_bucket" "chaganote-static-honey-web" {
  bucket = local.aws_s3_bucket # the bucket's name will be listed as "chaganote-static-honey-web"
}

# Create CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "main" {
  name = "my-oac2"
  description = "Origin Access Control for accessing S3 bucket via CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# Create CloudFront distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  aliases             = [local.domain]
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  wait_for_deployment = true

  default_cache_behavior {
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  cached_methods         = ["GET", "HEAD", "OPTIONS"]
  target_origin_id       = "S3Origin"
  viewer_protocol_policy = "redirect-to-https"

  forwarded_values {
    query_string = false

    cookies {
      forward = "none"
    }
  }

  min_ttl                = 0
  default_ttl            = 86400  # You can adjust the TTL values
  max_ttl                = 31536000
}


  origin {
    domain_name              = aws_s3_bucket.chaganote-static-honey-web.bucket_regional_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

# Define Data source for IAM policy
data "aws_iam_policy_document" "cloudfront_generated_policy" {
  statement {
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.chaganote-static-honey-web.arn}/*"]

    condition {
      test    = "StringEquals"
      values  = [aws_cloudfront_distribution.main.arn]
      variable = "AWS:SourceArn"
    }
  }
}

# Apply the policy above to the S3 buckets
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.chaganote-static-honey-web.id
  policy = data.aws_iam_policy_document.cloudfront_generated_policy.json
}

# Route 53 Record for CloudFront
resource "aws_route53_record" "main" {
  name = local.domain
  type = "A"
  zone_id = local.hosted_zone_id

  alias {
    evaluate_target_health = false
    name = aws_cloudfront_distribution.main.domain_name
    zone_id = aws_cloudfront_distribution.main.hosted_zone_id
  }
}
