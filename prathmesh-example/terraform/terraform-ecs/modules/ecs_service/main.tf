resource "aws_ecs_service" "aws_ecs_service" {
    name = "todo-ecs-service"
    cluster = var.aws_ecs_cluster_id
    task_definition = var.task_definition_arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = var.subnets
      security_groups = var.security_groups
      assign_public_ip = true
    }
}