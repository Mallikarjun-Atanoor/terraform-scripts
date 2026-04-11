output "bucket_name" {
  value = aws_s3_bucket.datalake.bucket
}

output "glue_database" {
  value = aws_glue_catalog_database.datalake_db.name
}


output "athena_results_bucket" {
  value = aws_s3_bucket.athena_results.bucket
}