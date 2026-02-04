variable "region" {
  type = string
}
variable "frontend_image" {}
variable "backend_image" {}
variable "db_image" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "MONGO_URL" {}