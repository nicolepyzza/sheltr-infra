resource "aws_s3_bucket" "sheltr_web" {
  bucket = "www.sheltr.pet"
}

resource "aws_s3_bucket_versioning" "sheltr_web" {
  bucket = aws_s3_bucket.sheltr_web.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "sheltr_web" {
  bucket = aws_s3_bucket.sheltr_web.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.sheltr_web.arn,
      "${aws_s3_bucket.sheltr_web.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "sheltr_web" {
  bucket = aws_s3_bucket.sheltr_web.id

  index_document {
    suffix = "index.html"
  }
}

output "sheltr_domain" {
  value = aws_s3_bucket_website_configuration.sheltr_web.website_domain
}

output "sheltr_endpoint" {
  value = aws_s3_bucket_website_configuration.sheltr_web.website_endpoint
}