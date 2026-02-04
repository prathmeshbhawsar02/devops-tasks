variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default = "ami-019715e0d74f695be"

}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
