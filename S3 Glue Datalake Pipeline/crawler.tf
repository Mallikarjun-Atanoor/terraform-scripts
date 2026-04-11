resource "aws_glue_crawler" "orders_raw_crawler" {
  name          = "orders-raw-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.datalake_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.datalake.bucket}/raw/orders/"
  }

  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "LOG"
  }
}