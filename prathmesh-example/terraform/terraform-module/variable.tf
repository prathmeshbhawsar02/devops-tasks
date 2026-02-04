variable "region" {
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}
variable "az" {
  default = "ap-south-1a"
}
variable "ami_id" {
  default = "ami-019715e0d74f695be"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "env" {
  default = "dev"
}
  

