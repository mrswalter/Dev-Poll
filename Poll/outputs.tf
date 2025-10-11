# 🟢 Poll App Outputs
# output "poll_app_task_def_arn" {
#   description = "ARN of the poll-app ECS task definition"
#   value       = aws_ecs_task_definition.poll_app_task_def_arn
# }

# output "poll_app_task_def_arn" {
#   value = aws_ecs_task_definition.poll_app.arn
# }



# 🔵 Grafana Outputs
output "grafana_task_def_arn" {
  description = "ARN of the Grafana ECS task definition"
  value       = module.grafana.grafana_task_def_arn
}

# 🟣 Prometheus Outputs
output "prometheus_task_def_arn" {
  description = "ARN of the Prometheus ECS task definition"
  value       = module.prometheus.prometheus_task_def_arn
}

output "efs_prometheus_id" {
  description = "ID of the EFS file system used by Prometheus"
  value       = module.efs.prometheus_id
}

# 🟠 IAM Outputs
output "execution_role_arn" {
  description = "IAM execution role ARN"
  value       = module.iam.execution_role_arn
}

output "task_role_arn" {
  description = "IAM task role ARN"
  value       = module.iam.task_role_arn
}

# 🟡 ALB Outputs
output "alb_dns" {
  description = "Public URL of the app"
  value       = module.alb.alb_dns
}

output "alb_dns_name" {
  description = "URL of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_sg_id" {
  description = "Security Group ID for the ALB"
  value       = module.security_group.alb_sg_id
}

# 🟤 RDS Outputs
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_host
}

output "rds_port" {
  description = "RDS Port"
  value       = module.rds.db_port
}

# ⚫ ECS Cluster Output
output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs_cluster.cluster_id
}

