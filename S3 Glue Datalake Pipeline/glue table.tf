resource "aws_glue_catalog_table" "orders_raw" {
  name          = "orders_raw"
  database_name = aws_glue_catalog_database.datalake_db.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    classification = "csv"
  }

  storage_descriptor {
    location      = "s3://s3-glue-job-datalake-9087/raw/orders/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = ","
      }
    }

    columns {
      name = "order_id"
      type = "int"
    }

    columns {
      name = "customer_name"
      type = "string"
    }

    columns {
      name = "amount"
      type = "string"
    }

    columns {
      name = "order_date"
      type = "string"
    }

    columns {
      name = "status"
      type = "string"
    }
  }
}