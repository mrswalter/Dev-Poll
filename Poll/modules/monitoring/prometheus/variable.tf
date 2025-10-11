variable "ecs_cluster_id" {}
variable "private_subnets" { type = list(string) }
variable "prometheus_efs_id" {}
variable "prometheus_sg_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

