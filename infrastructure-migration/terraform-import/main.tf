resource "aws_instance" "imported_servers" {
  for_each = {
    instance_1 = "i-03f9c8a7d2e14b6f1"
    instance_2 = "i-0b7e91c4a2d8f5e30"
    instance_3 = "i-08d1f6b9c2e7a4f55"
    instance_4 = "i-0c4e8b9d6f1a7e230"
    instance_5 = "i-0f2a7b8c9d4e1a650"
    instance_6 = "i-019a7e4b8d2f6c350"
  }
   instance_type = "m4.large" #dummy to satisfy schema
   ami           = "ami-1234567890abcdef0" # dummy to satisfy schema
}
