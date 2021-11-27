resource "aws_s3_bucket" "website" {
  provider = aws.deployment
  bucket = var.bucket_name
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  tags = var.tags
}

resource "aws_s3_bucket_policy" "bucket" {
  provider = aws.deployment
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  provider = aws.deployment
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values = [local.cdn_user_agent]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.website.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:UserAgent"
      values = [local.cdn_user_agent]
    }
  }
}