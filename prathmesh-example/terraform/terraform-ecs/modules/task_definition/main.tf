resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "todo-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "mongo"
      image = var.db_image


      portMappings = [
        {
          containerPort = 27017
          protocol      = "tcp"
        }
      ]



      healthCheck = {
        command     = ["CMD-SHELL", "mongosh -u username -p password --authenticationDatabase admin --eval \"db.adminCommand('ping')\""]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 20
      }


      essential = false
      environment = [
        { name = "MONGO_INITDB_ROOT_USERNAME", value = "username" },
        { name = "MONGO_INITDB_ROOT_PASSWORD", value = "password" }
      ]


    },

    {
      name  = "backend"
      image = var.backend_image

      portMappings = [
        {
          containerPort = 3001
          protocol      = "tcp"
        }
      ]

      dependsOn = [
        {
          containerName = "mongo"
          condition     = "HEALTHY"
        }
      ]

      essential = false

      environment = [
        {
          name  = "MONGO_URL"
          value = var.MONGO_URL
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/todo-task-definition"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "backend"
        }
      }


    },

    {
      name  = "frontend"
      image = var.frontend_image

      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]


      dependsOn = [
        {
          containerName = "backend"
          condition     = "START"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/todo-task-definition"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "frontend"
        }
      }


      environment = [
        {
          name  = "REACT_APP_API_URL",
          value = "http://localhost:3001"
        }
      ]

      essential = true




    }
  ])
}
