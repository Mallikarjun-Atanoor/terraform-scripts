# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "mallikarjun-images-archival"
resource "aws_s3_bucket" "imported_bucket_1" {
  bucket              = "bucket-images-archival"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "ap-south-1"
  tags                = {}
  tags_all            = {}
}

# __generated__ by Terraform from "hello.bucket.testing"
resource "aws_s3_bucket" "imported_bucket_2" {
  bucket              = "hello.bucket.testing"
  bucket_prefix       = null
  force_destroy       = false
  object_lock_enabled = false
  region              = "ap-south-1"
  tags                = {}
  tags_all            = {}
}
