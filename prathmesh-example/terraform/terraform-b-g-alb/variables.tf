variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type =list(string) 
}
variable "blue_asg_name" {
  type = string
}
variable "green_asg_name" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}