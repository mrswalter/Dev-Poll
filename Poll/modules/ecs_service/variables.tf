variable "project_name" {
  description = "Base name for ECS resources"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster to deploy into"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for the ECS task itself"
  type        = string
}

variable "app_image" {
  description = "Docker image for the poll-app container"
  type        = string
}

variable "prometheus_image" {
  description = "Docker image for the Prometheus container"
  type        = string
}

variable "db_host" {
  description = "Database host for poll-app"
  type        = string
}

variable "db_name" {
  description = "Database name for poll-app"
  type        = string
}

variable "db_user" {
  description = "Database user for poll-app"
  type        = string
}

variable "db_password" {
  description = "Database password for poll-app"
  type        = string
  sensitive   = true
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS networking"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for poll-app container"
  type        = string
}

variable "listener_arn" {
  description = "Listener ARN for ALB dependency"
  type        = string
}

variable "prometheus_efs_id" {
  description = "EFS file system ID for Prometheus config"
  type        = string
}

variable "prometheus_config_access_point_id" {
  description = "EFS access point ID for Prometheus config"
  type        = string
}