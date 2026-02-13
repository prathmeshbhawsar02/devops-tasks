region = "ap-south-1"

vpc_id = "vpc-098357d64d5cb60fb"

public_subnets = [
  "subnet-004f7705962d6b5cd",
  "subnet-08dafc92f9697866b",
  "subnet-07af6bfd69ea5aab6"
]

blue_asg_name  = "ASG-Blue"
green_asg_name = "ASG-green"

alb_security_group_id = "sg-0b99e81d82501d5a6"

#certificate_arn = "arn:aws:acm:ap-south-1:123456789012:certificate/xxxxxxxx"