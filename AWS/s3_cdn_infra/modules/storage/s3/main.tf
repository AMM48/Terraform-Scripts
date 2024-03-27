// create the s3 bucket
resource "aws_s3_bucket" "portfolio_website" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  tags = {
    Name = "Portfolio Website"
  }
}

// remove public access restrictions
resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.portfolio_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// add bucket policy to allow cloudfront to access the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.portfolio_website.id

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${var.cloudfront_distribution_arn}"
                }
            }
        }
    ]
}
EOF

  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
}
