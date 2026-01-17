terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  alias = "primary"
}



provider "aws" {
  region = "us-east-1"
  alias = "secondary"
}