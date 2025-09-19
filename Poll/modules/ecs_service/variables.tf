variable "project_name" {}
variable "ecs_cluster_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "private_subnets" { type = list(string) }
variable "ecs_sg_id" {}
variable "target_group_arn" {}
variable "listener_arn" {}
variable "app_image" {}
variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "db_port" {}
variable "db_host" {
  description = "Hostname of the RDS instance"
  type        = string
}

