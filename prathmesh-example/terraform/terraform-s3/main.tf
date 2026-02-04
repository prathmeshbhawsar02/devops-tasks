provider "aws" {
  region = "ap-south-1"
}


resource "aws_s3_bucket" "name" {
  bucket = "prathmesh-s3-bucket"
}