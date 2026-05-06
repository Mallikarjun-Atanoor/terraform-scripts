resource "aws_s3_object" "raw_orders" {
  bucket  = aws_s3_bucket.datalake.id
  key     = "raw/orders/"
  content = ""
}

resource "aws_s3_object" "curated_orders" {
  bucket  = aws_s3_bucket.datalake.id
  key     = "curated/orders/"
  content = ""
}

resource "aws_s3_object" "processed_orders" {
  bucket  = aws_s3_bucket.datalake.id
  key     = "processed/orders/"
  content = ""
}
