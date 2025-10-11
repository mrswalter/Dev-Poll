variable "ecs_cluster_id" {}
variable "private_subnets" { type = list(string) }
variable "grafana_sg_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "grafana_image" { default = "grafana/grafana:latest" }
# variable "grafana_admin_password" { default = "" }
# variable "listener_arn" {}
variable "target_group_arn" {}

