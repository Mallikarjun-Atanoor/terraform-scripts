resource "aws_athena_workgroup" "main" {
  name = "primary-workgroup"

  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
    }
  }
}