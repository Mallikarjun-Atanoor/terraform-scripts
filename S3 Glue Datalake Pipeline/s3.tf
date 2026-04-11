resource "aws_s3_bucket" "datalake" {
  bucket = "s3-glue-job-datalake-9087"   # must be globally unique


  tags = {
    Name        = "Glue Data Lake"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.datalake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "athena-query-results-9087"
}