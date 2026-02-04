resource "aws_instance" "ec2_by_module" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    security_groups = [var.sg]
    associate_public_ip_address = true
    tags = merge(
        var.tags,
        { Name= "ec2-by-modules"}
    )
    user_data = <<-EOF
              #!/bin/bash
              sudo apt -y update
              sudo apt install -y git
              sudo apt install -y ansible
              cd /home/ubuntu/
              
              git clone https://github.com/knaopel/docker-frontend-backend-db.git
              
              git clone https://github.com/prathmeshbhawsar02/docker-todo.git
            
              cd /home/ubuntu/docker-todo/
              ansible-playbook -i inventory.ini playbook.yml


              EOF
}