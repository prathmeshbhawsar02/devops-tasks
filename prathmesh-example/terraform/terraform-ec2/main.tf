provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "web" {

   ami =  var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "terraform-ec2"
  }
  user_data = <<EOF
          
          
  
  EOF
}