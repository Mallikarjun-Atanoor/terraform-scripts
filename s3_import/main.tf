variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-south-1"
}

provider "aws" {
  region = "ap-south-1"
} 

import {
  to = aws_s3_bucket.imported_bucket_1
  id = "mallikarjun-images-archival"
}

import {
  to = aws_s3_bucket.imported_bucket_2
  id = "hello.bucket.testing"
}


