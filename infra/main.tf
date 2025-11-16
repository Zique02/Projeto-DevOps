provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "devopsnapratica_bucket" {
  bucket = "devopsnapratica-deploy-bucket"
}

resource "aws_s3_bucket_ownership_controls" "devopsnapratica_bucket" {
  bucket = aws_s3_bucket.devopsnapratica_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "devopsnapratica_bucket" {
  bucket = aws_s3_bucket.devopsnapratica_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "devopsnapratica_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.devopsnapratica_bucket,
    aws_s3_bucket_public_access_block.devopsnapratica_bucket
  ]

  bucket = aws_s3_bucket.devopsnapratica_bucket.id
  acl    = "public-read"

}
