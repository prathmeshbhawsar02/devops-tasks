data "aws_autoscaling_group" "blue" {
  name = var.blue_asg_name
}

data "aws_autoscaling_group" "green" {
  name = var.green_asg_name
}


# load balancer

resource "aws_lb" "app_alb" {
  name = "todo-app-alb"
  load_balancer_type = "application"
  security_groups = [var.alb_security_group_id]
  subnets = var.public_subnets

  tags = {
    Name = "todo-app-alb"
    Environment = "production"
    }
}


# target groups(blue)

resource "aws_lb_target_group" "blue_tg" {
    name = "blue-target-group"
    port = 3000
    protocol = "HTTP"
    vpc_id = var.vpc_id




}


# target group(green)

resource "aws_lb_target_group" "green_tg" {
    name = "green-target-group"
    port = 3000
    protocol = "HTTP"
    vpc_id = var.vpc_id

    tags = {
        Environment = "blue"
    }
}


# ASG attach

resource "aws_autoscaling_attachment" "blue_attach" {
    autoscaling_group_name = data.aws_autoscaling_group.blue.name
    lb_target_group_arn = aws_lb_target_group.blue_tg.arn
}

resource "aws_autoscaling_attachment" "green_attach" {
    autoscaling_group_name = data.aws_autoscaling_group.green.name
    lb_target_group_arn = aws_lb_target_group.green_tg.arn
}



# listenser

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port = 3000
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.green_tg.arn
  }

}