variable "s3_project_bucket" {
    default  = "s3-web-project-1007"
}

locals {
  origin_id = "s3-${aws_s3_bucket.project_bucket.id}"
}