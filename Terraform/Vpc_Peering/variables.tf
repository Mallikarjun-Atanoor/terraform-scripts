variable "primary" {
    type = string
    default = "ap-south-1"
}

variable "secondary" {
    type = string
    default = "us-east-1"
}

variable "primary_vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
    type = string
    default = "10.1.0.0/16"
}

variable "primary_key_name" {
  type = string
}

variable "secondary_key_name" {
  type = string
}
