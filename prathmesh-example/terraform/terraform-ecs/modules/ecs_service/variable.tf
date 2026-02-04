variable "aws_ecs_cluster_id" {}
variable "task_definition_arn" {}
variable "subnets" {
  type = list(string)
}

variable "security_groups" {
    type = list(string)
}