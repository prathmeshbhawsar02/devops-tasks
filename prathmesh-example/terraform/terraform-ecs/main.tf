module "ecs_cluster" {
  source = "./modules/ecs_cluster"
}


module "iam" {
  source = "./modules/iam"
}


module "task_definition" {
  source = "./modules/task_definition"


  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  backend_image      = var.backend_image
  frontend_image     = var.frontend_image
  db_image           = var.db_image
  MONGO_URL          = var.MONGO_URL
}

module "ecs_service" {
  source = "./modules/ecs_service"

  aws_ecs_cluster_id = module.ecs_cluster.aws_ecs_cluster_id

  task_definition_arn = module.task_definition.task_definition_arn
  subnets             = var.subnets
  security_groups     = var.security_groups
}

