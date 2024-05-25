// create the s3 bucket
resource "aws_s3_bucket" "petcuddleotron" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  tags = {
    Name = "Petcuddleotron"
  }
}

// remove public access restrictions
resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.petcuddleotron.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// add bucket policy to allow cloudfront to access the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.petcuddleotron.id

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

data "template_file" "script" {
  template = file(".\\modules\\storage\\s3\\files\\serverless.js.tpl")

  vars = {
    arn    = var.step_functions_arn
    domain = var.domain_name
  }
}

resource "aws_s3_object" "script_object" {
  bucket       = aws_s3_bucket.petcuddleotron.id
  key          = "serverless.js"
  content      = data.template_file.script.rendered
  content_type = "application/javascript"
}

resource "aws_s3_object" "html_object" {
  bucket       = aws_s3_bucket.petcuddleotron.id
  key          = "index.html"
  source       = ".\\modules\\storage\\s3\\files\\index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css_object" {
  bucket       = aws_s3_bucket.petcuddleotron.id
  key          = "main.css"
  source       = ".\\modules\\storage\\s3\\files\\main.css"
  content_type = "text/css"
}

resource "aws_s3_object" "image_object" {
  bucket       = aws_s3_bucket.petcuddleotron.id
  key          = "whiskers.png"
  source       = ".\\modules\\storage\\s3\\files\\whiskers.png"
  content_type = "image/png"
}
